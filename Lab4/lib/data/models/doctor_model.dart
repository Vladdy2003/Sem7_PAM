import '../../domain/entities/doctor.dart';

// DTO (Data Transfer Object) pentru un element din "nearbyDoctors".
// fromJson = deserializare, toJson = serializare, toEntity = conversie spre Domain.
class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String distance;
  final String avatarUrl;
  final bool isFavorite;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.distance,
    required this.avatarUrl,
    required this.isFavorite,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        specialty: json['specialty'] as String? ?? '',
        distance: json['distance'] as String? ?? '',
        avatarUrl: json['avatarUrl'] as String? ?? '',
        isFavorite: json['isFavorite'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'specialty': specialty,
        'distance': distance,
        'avatarUrl': avatarUrl,
        'isFavorite': isFavorite,
      };

  Doctor toEntity() => Doctor(
        id: id,
        name: name,
        specialty: specialty,
        distance: distance,
        avatarUrl: avatarUrl,
        isFavorite: isFavorite,
      );
}
