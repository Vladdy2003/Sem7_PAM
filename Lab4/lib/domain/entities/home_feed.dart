import 'package:equatable/equatable.dart';

import 'doctor.dart';

// Entitatile Domain pentru ecranul principal (vin din GET /feed).

class UserProfile extends Equatable {
  final String name;
  final String greeting;
  final String subtitle;
  final String avatarUrl;

  const UserProfile({
    required this.name,
    required this.greeting,
    required this.subtitle,
    required this.avatarUrl,
  });

  @override
  List<Object?> get props => [name, greeting, subtitle, avatarUrl];
}

class AppointmentDoctor extends Equatable {
  final String name;
  final String specialty;
  final String avatarUrl;

  const AppointmentDoctor({
    required this.name,
    required this.specialty,
    required this.avatarUrl,
  });

  @override
  List<Object?> get props => [name, specialty, avatarUrl];
}

class UpcomingAppointment extends Equatable {
  final String title;
  final String date;
  final String time;
  final AppointmentDoctor doctor;

  const UpcomingAppointment({
    required this.title,
    required this.date,
    required this.time,
    required this.doctor,
  });

  @override
  List<Object?> get props => [title, date, time, doctor];
}

class HealthService extends Equatable {
  final String id;
  final String name;
  final String iconUrl;

  const HealthService({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  @override
  List<Object?> get props => [id, name, iconUrl];
}

class HomeFeed extends Equatable {
  final UserProfile user;
  final bool hasUnreadNotifications;
  final String searchHint;
  final UpcomingAppointment appointment;
  final List<HealthService> healthServices;
  final List<Doctor> nearbyDoctors;

  const HomeFeed({
    required this.user,
    required this.hasUnreadNotifications,
    required this.searchHint,
    required this.appointment,
    required this.healthServices,
    required this.nearbyDoctors,
  });

  @override
  List<Object?> get props => [
        user,
        hasUnreadNotifications,
        searchHint,
        appointment,
        healthServices,
        nearbyDoctors,
      ];
}
