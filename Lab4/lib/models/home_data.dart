import 'package:equatable/equatable.dart';

import 'doctor.dart';

// Modelele pentru raspunsul GET /feed

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

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String? ?? '',
        greeting: json['greeting'] as String? ?? '',
        subtitle: json['subtitle'] as String? ?? '',
        avatarUrl: json['avatarUrl'] as String? ?? '',
      );

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

  factory AppointmentDoctor.fromJson(Map<String, dynamic> json) =>
      AppointmentDoctor(
        name: json['name'] as String? ?? '',
        specialty: json['specialty'] as String? ?? '',
        avatarUrl: json['avatarUrl'] as String? ?? '',
      );

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

  factory UpcomingAppointment.fromJson(Map<String, dynamic> json) =>
      UpcomingAppointment(
        title: json['title'] as String? ?? '',
        date: json['date'] as String? ?? '',
        time: json['time'] as String? ?? '',
        doctor: AppointmentDoctor.fromJson(
            json['doctor'] as Map<String, dynamic>? ?? const {}),
      );

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

  factory HealthService.fromJson(Map<String, dynamic> json) => HealthService(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        iconUrl: json['iconUrl'] as String? ?? '',
      );

  @override
  List<Object?> get props => [id, name, iconUrl];
}

class HomeData extends Equatable {
  final UserProfile user;
  final bool hasUnreadNotifications;
  final String searchHint;
  final UpcomingAppointment appointment;
  final List<HealthService> healthServices;
  final List<Doctor> nearbyDoctors;

  const HomeData({
    required this.user,
    required this.hasUnreadNotifications,
    required this.searchHint,
    required this.appointment,
    required this.healthServices,
    required this.nearbyDoctors,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        user: UserProfile.fromJson(json['user'] as Map<String, dynamic>),
        hasUnreadNotifications:
            (json['notifications'] as Map<String, dynamic>?)?['hasUnread']
                    as bool? ??
                false,
        searchHint:
            (json['search'] as Map<String, dynamic>?)?['hint'] as String? ??
                'Search',
        appointment: UpcomingAppointment.fromJson(
            json['appointment'] as Map<String, dynamic>),
        healthServices: (json['healthServices'] as List<dynamic>? ?? [])
            .map((e) => HealthService.fromJson(e as Map<String, dynamic>))
            .toList(),
        nearbyDoctors: (json['nearbyDoctors'] as List<dynamic>? ?? [])
            .map((e) => Doctor.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

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
