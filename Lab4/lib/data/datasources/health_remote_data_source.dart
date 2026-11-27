import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/error/exceptions.dart';
import '../../core/network/api_config.dart';
import '../models/appointment_details_model.dart';
import '../models/home_feed_model.dart';

// Sursa de date remote: singurul loc din aplicatie care face cereri HTTP.
// Returneaza DTO-uri (modele Data) sau arunca exceptii din core/error.
abstract class HealthRemoteDataSource {
  Future<HomeFeedModel> fetchHomeFeed();

  Future<AppointmentDetailsModel> fetchAppointmentDetails();
}

class HealthRemoteDataSourceImpl implements HealthRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  final Duration timeout;

  HealthRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConfig.baseUrl,
    this.timeout = ApiConfig.timeout,
  });

  @override
  Future<HomeFeedModel> fetchHomeFeed() async {
    final json = await _getJson(ApiConfig.feedPath);
    return _parse(() => HomeFeedModel.fromJson(json), ApiConfig.feedPath);
  }

  @override
  Future<AppointmentDetailsModel> fetchAppointmentDetails() async {
    final json = await _getJson(ApiConfig.feedDetailsPath);
    return _parse(
        () => AppointmentDetailsModel.fromJson(json), ApiConfig.feedDetailsPath);
  }

  // GET + verificarea codului HTTP + decodarea JSON-ului
  Future<Map<String, dynamic>> _getJson(String path) async {
    final uri = Uri.parse('$baseUrl$path');

    final http.Response response;
    try {
      response = await client
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(timeout);
    } on TimeoutException {
      throw NetworkException('GET $path: the server did not respond in time');
    } on http.ClientException catch (e) {
      throw NetworkException('GET $path: ${e.message}');
    }

    if (response.statusCode != 200) {
      throw ServerException(
          response.statusCode, 'GET $path failed (HTTP ${response.statusCode})');
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw ParsingException('GET $path returned invalid JSON');
    }
    if (decoded is! Map<String, dynamic>) {
      throw ParsingException('GET $path returned an unexpected format');
    }
    return decoded;
  }

  // Deserializarea JSON -> DTO; un camp lipsa sau de alt tip => ParsingException
  T _parse<T>(T Function() fromJson, String path) {
    try {
      return fromJson();
    } on TypeError {
      throw ParsingException('GET $path: unexpected JSON structure');
    }
  }
}
