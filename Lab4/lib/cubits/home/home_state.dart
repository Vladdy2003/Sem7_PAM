import 'package:equatable/equatable.dart';

import '../../models/app_data.dart';
import '../../models/doctor.dart';

// Optiunile de sortare pentru lista de doctori
enum DoctorSort {
  none('Default'),
  nameAsc('Name A-Z'),
  nameDesc('Name Z-A'),
  distance('Nearest first');

  final String label;
  const DoctorSort(this.label);
}

// Starile ecranului principal: Initial -> Loading -> Success / Empty / Error
sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

// Stare comuna pentru Success si Empty: datele sunt incarcate,
// iar filtrele curente (cautare, specialitate, sortare, favorite) sunt pastrate.
sealed class HomeReady extends HomeState {
  final AppData data;
  final List<Doctor> visibleDoctors;
  final List<String> specialties;
  final String query;
  final String? specialty;
  final DoctorSort sort;
  final bool favoritesOnly;
  final int favoritesCount;

  const HomeReady({
    required this.data,
    required this.visibleDoctors,
    required this.specialties,
    required this.query,
    required this.specialty,
    required this.sort,
    required this.favoritesOnly,
    required this.favoritesCount,
  });

  bool get hasActiveFilters =>
      query.isNotEmpty ||
      specialty != null ||
      favoritesOnly ||
      sort != DoctorSort.none;

  @override
  List<Object?> get props => [
        data,
        visibleDoctors,
        specialties,
        query,
        specialty,
        sort,
        favoritesOnly,
        favoritesCount,
      ];
}

final class HomeSuccess extends HomeReady {
  const HomeSuccess({
    required super.data,
    required super.visibleDoctors,
    required super.specialties,
    required super.query,
    required super.specialty,
    required super.sort,
    required super.favoritesOnly,
    required super.favoritesCount,
  });
}

// Nu exista niciun doctor pentru filtrele curente (sau lista din JSON e goala)
final class HomeEmpty extends HomeReady {
  const HomeEmpty({
    required super.data,
    required super.specialties,
    required super.query,
    required super.specialty,
    required super.sort,
    required super.favoritesOnly,
    required super.favoritesCount,
  }) : super(visibleDoctors: const []);
}
