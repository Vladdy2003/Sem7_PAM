import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/app_data.dart';
import '../models/appointment_details.dart';
import '../models/home_data.dart';

// Sursa de date a aplicatiei. Abstracta, ca sa poata fi inlocuita
// (de ex. cu un fake in teste).
abstract class HealthRepository {
  Future<AppData> loadAppData();
}

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

// Incarca datele de la API-ul remote:
//   GET /lab2026/v2/feed          -> ecranul principal (homeScreen)
//   GET /lab2026/v2/feed/details  -> detaliile programarii (appointmentDetails)
class ApiHealthRepository implements HealthRepository {
  static const defaultBaseUrl = 'https://test-api-jlbn.onrender.com/lab2026/v2';

  final http.Client _client;
  final String baseUrl;
  // Serverul de pe Render poate "dormi" si porneste greu la primul request
  final Duration timeout;

  ApiHealthRepository({
    http.Client? client,
    this.baseUrl = defaultBaseUrl,
    this.timeout = const Duration(seconds: 60),
  }) : _client = client ?? http.Client();

  @override
  Future<AppData> loadAppData() async {
    // cele doua cereri pornesc in paralel
    final results = await Future.wait([
      _getJson('/feed'),
      _getJson('/feed/details'),
    ]);

    return AppData(
      home: HomeData.fromJson(results[0]),
      appointmentDetails: AppointmentDetails.fromJson(results[1]),
    );
  }

  Future<Map<String, dynamic>> _getJson(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _client
        .get(uri, headers: const {'Accept': 'application/json'})
        .timeout(timeout);

    if (response.statusCode != 200) {
      throw ApiException('GET $path failed (HTTP ${response.statusCode})');
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! Map<String, dynamic>) {
      throw ApiException('GET $path returned an unexpected format');
    }
    return decoded;
  }
}
