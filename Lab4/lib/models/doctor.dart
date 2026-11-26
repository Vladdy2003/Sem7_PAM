import 'package:equatable/equatable.dart';

// Un doctor din lista "nearbyDoctors"
class Doctor extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final String distance;
  final String avatarUrl;
  final bool isFavorite;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.distance,
    required this.avatarUrl,
    this.isFavorite = false,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        specialty: json['specialty'] as String? ?? '',
        distance: json['distance'] as String? ?? '',
        avatarUrl: json['avatarUrl'] as String? ?? '',
        isFavorite: json['isFavorite'] as bool? ?? false,
      );

  /// Distanta in metri extrasa din text ("... - 500M from you" -> 500).
  /// Folosita la sortarea dupa distanta.
  int get distanceMeters {
    final match = RegExp(r'(\d+)\s*M\b').firstMatch(distance);
    return match == null ? 1 << 30 : int.parse(match.group(1)!);
  }

  Doctor copyWith({bool? isFavorite}) => Doctor(
        id: id,
        name: name,
        specialty: specialty,
        distance: distance,
        avatarUrl: avatarUrl,
        isFavorite: isFavorite ?? this.isFavorite,
      );

  @override
  List<Object?> get props =>
      [id, name, specialty, distance, avatarUrl, isFavorite];
}
