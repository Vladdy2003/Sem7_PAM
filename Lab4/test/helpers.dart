import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab4/core/error/failures.dart';
import 'package:lab4/core/result.dart';
import 'package:lab4/domain/entities/appointment_details.dart';
import 'package:lab4/domain/entities/home_feed.dart';
import 'package:lab4/domain/repositories/health_repository.dart';
import 'package:lab4/injection_container.dart';

// Client HTTP fals: raspunde cu copii ale raspunsurilor reale ale API-ului
// (test/fixtures), fara retea. Restul lantului (data source, DTO-uri,
// repository, use case-uri, cubit-uri) este codul real al aplicatiei.
MockClient fixtureClient({int statusCode = 200}) => MockClient((request) async {
      final file = switch (request.url.path) {
        '/lab2026/v2/feed' => 'test/fixtures/feed.json',
        '/lab2026/v2/feed/details' => 'test/fixtures/feed_details.json',
        _ => null,
      };
      if (file == null) return http.Response('not found', 404);
      if (statusCode != 200) return http.Response('error', statusCode);
      return http.Response.bytes(File(file).readAsBytesSync(), 200,
          headers: {'content-type': 'application/json'});
    });

HealthRepository fakeApiRepository() =>
    createHealthRepository(client: fixtureClient());

// Repository care esueaza mereu (pentru starile de eroare)
class FailingRepository implements HealthRepository {
  @override
  Future<Result<HomeFeed>> getHomeFeed() async =>
      const ResultFailure(NetworkFailure('boom'));

  @override
  Future<Result<AppointmentDetails>> getAppointmentDetails() async =>
      const ResultFailure(NetworkFailure('boom'));
}

// /feed functioneaza, dar /feed/details esueaza
class DetailsFailingRepository implements HealthRepository {
  final HealthRepository _ok = fakeApiRepository();

  @override
  Future<Result<HomeFeed>> getHomeFeed() => _ok.getHomeFeed();

  @override
  Future<Result<AppointmentDetails>> getAppointmentDetails() async =>
      const ResultFailure(ServerFailure('HTTP 500'));
}
