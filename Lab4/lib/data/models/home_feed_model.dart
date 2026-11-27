import '../../domain/entities/home_feed.dart';
import 'doctor_model.dart';

// DTO-urile pentru raspunsul JSON de la GET /feed.
// fromJson = deserializare, toJson = serializare, toEntity = conversie spre Domain.

class UserProfileModel {
  final String name;
  final String greeting;
  final String subtitle;
  final String avatarUrl;

  const UserProfileModel({
    required this.name,
    required this.greeting,
    required this.subtitle,
    required this.avatarUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        name: json['name'] as String? ?? '',
        greeting: json['greeting'] as String? ?? '',
        subtitle: json['subtitle'] as String? ?? '',
        avatarUrl: json['avatarUrl'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'greeting': greeting,
        'subtitle': subtitle,
        'avatarUrl': avatarUrl,
      };

  UserProfile toEntity() => UserProfile(
        name: name,
        greeting: greeting,
        subtitle: subtitle,
        avatarUrl: avatarUrl,
      );
}

class AppointmentDoctorModel {
  final String name;
  final String specialty;
  final String avatarUrl;

  const AppointmentDoctorModel({
    required this.name,
    required this.specialty,
    required this.avatarUrl,
  });

  factory AppointmentDoctorModel.fromJson(Map<String, dynamic> json) =>
      AppointmentDoctorModel(
        name: json['name'] as String? ?? '',
        specialty: json['specialty'] as String? ?? '',
        avatarUrl: json['avatarUrl'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'specialty': specialty,
        'avatarUrl': avatarUrl,
      };

  AppointmentDoctor toEntity() => AppointmentDoctor(
        name: name,
        specialty: specialty,
        avatarUrl: avatarUrl,
      );
}

class UpcomingAppointmentModel {
  final String title;
  final String date;
  final String time;
  final AppointmentDoctorModel doctor;

  const UpcomingAppointmentModel({
    required this.title,
    required this.date,
    required this.time,
    required this.doctor,
  });

  factory UpcomingAppointmentModel.fromJson(Map<String, dynamic> json) =>
      UpcomingAppointmentModel(
        title: json['title'] as String? ?? '',
        date: json['date'] as String? ?? '',
        time: json['time'] as String? ?? '',
        doctor: AppointmentDoctorModel.fromJson(
            json['doctor'] as Map<String, dynamic>? ?? const {}),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'date': date,
        'time': time,
        'doctor': doctor.toJson(),
      };

  UpcomingAppointment toEntity() => UpcomingAppointment(
        title: title,
        date: date,
        time: time,
        doctor: doctor.toEntity(),
      );
}

class HealthServiceModel {
  final String id;
  final String name;
  final String iconUrl;

  const HealthServiceModel({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  factory HealthServiceModel.fromJson(Map<String, dynamic> json) =>
      HealthServiceModel(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        iconUrl: json['iconUrl'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'iconUrl': iconUrl};

  HealthService toEntity() =>
      HealthService(id: id, name: name, iconUrl: iconUrl);
}

class HomeFeedModel {
  final UserProfileModel user;
  final bool hasUnreadNotifications;
  final String searchHint;
  final UpcomingAppointmentModel appointment;
  final List<HealthServiceModel> healthServices;
  final List<DoctorModel> nearbyDoctors;

  const HomeFeedModel({
    required this.user,
    required this.hasUnreadNotifications,
    required this.searchHint,
    required this.appointment,
    required this.healthServices,
    required this.nearbyDoctors,
  });

  factory HomeFeedModel.fromJson(Map<String, dynamic> json) => HomeFeedModel(
        user: UserProfileModel.fromJson(json['user'] as Map<String, dynamic>),
        hasUnreadNotifications:
            (json['notifications'] as Map<String, dynamic>?)?['hasUnread']
                    as bool? ??
                false,
        searchHint:
            (json['search'] as Map<String, dynamic>?)?['hint'] as String? ??
                'Search',
        appointment: UpcomingAppointmentModel.fromJson(
            json['appointment'] as Map<String, dynamic>),
        healthServices: (json['healthServices'] as List<dynamic>? ?? [])
            .map((e) => HealthServiceModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        nearbyDoctors: (json['nearbyDoctors'] as List<dynamic>? ?? [])
            .map((e) => DoctorModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'notifications': {'hasUnread': hasUnreadNotifications},
        'search': {'hint': searchHint},
        'appointment': appointment.toJson(),
        'healthServices': healthServices.map((e) => e.toJson()).toList(),
        'nearbyDoctors': nearbyDoctors.map((e) => e.toJson()).toList(),
      };

  HomeFeed toEntity() => HomeFeed(
        user: user.toEntity(),
        hasUnreadNotifications: hasUnreadNotifications,
        searchHint: searchHint,
        appointment: appointment.toEntity(),
        healthServices: healthServices.map((e) => e.toEntity()).toList(),
        nearbyDoctors: nearbyDoctors.map((e) => e.toEntity()).toList(),
      );
}
