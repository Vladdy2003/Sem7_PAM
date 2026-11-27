import 'package:equatable/equatable.dart';

// Entitate Domain: un doctor din lista "Nearby Doctor".
// Nu stie nimic despre JSON sau HTTP (asta e treaba stratului Data).
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
