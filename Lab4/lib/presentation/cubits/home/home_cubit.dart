import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/doctor.dart';
import '../../../domain/entities/home_feed.dart';
import '../../../domain/usecases/get_home_feed.dart';
import 'home_state.dart';

export 'home_state.dart';

// Presentation: gestioneaza starea ecranului principal.
// Datele vin prin use case-ul GetHomeFeed (Domain) -> repository -> API.
// Cautarea, filtrarea, sortarea si favoritele se fac local, fara cereri noi.
class HomeCubit extends Cubit<HomeState> {
  final GetHomeFeed _getHomeFeed;

  HomeFeed? _feed;
  List<Doctor> _doctors = const [];
  String _query = '';
  String? _specialty;
  DoctorSort _sort = DoctorSort.none;
  bool _favoritesOnly = false;

  HomeCubit(this._getHomeFeed) : super(const HomeInitial());

  Future<void> loadData() async {
    emit(const HomeLoading());
    final result = await _getHomeFeed();
    if (isClosed) return;
    result.fold(
      onSuccess: (feed) {
        _feed = feed;
        _doctors = List.of(feed.nearbyDoctors);
        _emitReady();
      },
      onFailure: (failure) =>
          emit(HomeError('Could not load data.\n${failure.message}')),
    );
  }

  void search(String query) {
    _query = query.trim();
    _emitReady();
  }

  void selectSpecialty(String? specialty) {
    _specialty = specialty;
    _emitReady();
  }

  void changeSort(DoctorSort sort) {
    _sort = sort;
    _emitReady();
  }

  void setFavoritesOnly(bool value) {
    _favoritesOnly = value;
    _emitReady();
  }

  void toggleFavorite(String doctorId) {
    _doctors = [
      for (final d in _doctors)
        d.id == doctorId ? d.copyWith(isFavorite: !d.isFavorite) : d,
    ];
    _emitReady();
  }

  void clearFilters() {
    _query = '';
    _specialty = null;
    _sort = DoctorSort.none;
    _favoritesOnly = false;
    _emitReady();
  }

  Doctor? doctorById(String id) {
    for (final d in _doctors) {
      if (d.id == id) return d;
    }
    return null;
  }

  // Aplica cautarea + filtrele + sortarea si emite Success sau Empty
  void _emitReady() {
    final feed = _feed;
    if (feed == null) return;

    final q = _query.toLowerCase();
    final visible = _doctors.where((d) {
      final matchesQuery = q.isEmpty ||
          d.name.toLowerCase().contains(q) ||
          d.specialty.toLowerCase().contains(q) ||
          d.distance.toLowerCase().contains(q);
      final matchesSpecialty = _specialty == null || d.specialty == _specialty;
      final matchesFavorite = !_favoritesOnly || d.isFavorite;
      return matchesQuery && matchesSpecialty && matchesFavorite;
    }).toList();

    switch (_sort) {
      case DoctorSort.none:
        break;
      case DoctorSort.nameAsc:
        visible.sort((a, b) => a.name.compareTo(b.name));
      case DoctorSort.nameDesc:
        visible.sort((a, b) => b.name.compareTo(a.name));
      case DoctorSort.distance:
        visible.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
    }

    final specialties = {for (final d in _doctors) d.specialty}.toList()
      ..sort();
    final favoritesCount = _doctors.where((d) => d.isFavorite).length;

    if (visible.isEmpty) {
      emit(HomeEmpty(
        feed: feed,
        specialties: specialties,
        query: _query,
        specialty: _specialty,
        sort: _sort,
        favoritesOnly: _favoritesOnly,
        favoritesCount: favoritesCount,
      ));
    } else {
      emit(HomeSuccess(
        feed: feed,
        visibleDoctors: visible,
        specialties: specialties,
        query: _query,
        specialty: _specialty,
        sort: _sort,
        favoritesOnly: _favoritesOnly,
        favoritesCount: favoritesCount,
      ));
    }
  }
}
