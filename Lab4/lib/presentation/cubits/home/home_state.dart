import 'package:equatable/equatable.dart';

import '../../../domain/entities/home_feed.dart';
import '../../../domain/entities/doctor.dart';

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
  final HomeFeed feed;
  final List<Doctor> visibleDoctors;
  final List<String> specialties;
  final String query;
  final String? specialty;
  final DoctorSort sort;
  final bool favoritesOnly;
  final int favoritesCount;

  const HomeReady({
    required this.feed,
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
        feed,
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
    required super.feed,
    required super.visibleDoctors,
    required super.specialties,
    required super.query,
    required super.specialty,
    required super.sort,
    required super.favoritesOnly,
    required super.favoritesCount,
  });
}

// Nu exista niciun doctor pentru filtrele curente (sau lista primita de la server e goala)
final class HomeEmpty extends HomeReady {
  const HomeEmpty({
    required super.feed,
    required super.specialties,
    required super.query,
    required super.specialty,
    required super.sort,
    required super.favoritesOnly,
    required super.favoritesCount,
  }) : super(visibleDoctors: const []);
}
