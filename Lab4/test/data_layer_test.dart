import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab4/core/error/failures.dart';
import 'package:lab4/core/result.dart';
import 'package:lab4/data/models/appointment_details_model.dart';
import 'package:lab4/data/models/home_feed_model.dart';
import 'package:lab4/domain/usecases/get_appointment_details.dart';
import 'package:lab4/domain/usecases/get_home_feed.dart';
import 'package:lab4/injection_container.dart';

import 'helpers.dart';

Map<String, dynamic> readFixture(String name) =>
    jsonDecode(File('test/fixtures/$name').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  group('Models (serializare / deserializare JSON)', () {
    test('HomeFeedModel: fromJson -> toJson -> fromJson', () {
      final model = HomeFeedModel.fromJson(readFixture('feed.json'));
      expect(model.user.name, 'Jonathan');
      expect(model.nearbyDoctors, isNotEmpty);

      final again = HomeFeedModel.fromJson(model.toJson());
      expect(again.toEntity(), model.toEntity());
    });

    test('AppointmentDetailsModel: fromJson -> toJson -> fromJson', () {
      final model =
          AppointmentDetailsModel.fromJson(readFixture('feed_details.json'));
      expect(model.doctor.name, 'Dr.Upul');
      expect(model.payment.amount, 120.0);

      final again = AppointmentDetailsModel.fromJson(model.toJson());
      expect(again.toEntity(), model.toEntity());
    });
  });

  group('Repository + use cases', () {
    test('success -> ResultSuccess cu entitati Domain', () async {
      final repo = fakeApiRepository();
      final feed = await GetHomeFeed(repo)();
      final details = await GetAppointmentDetails(repo)();

      expect(feed, isA<ResultSuccess>());
      expect(details, isA<ResultSuccess>());
    });

    test('HTTP 503 -> ServerFailure', () async {
      final repo = createHealthRepository(client: fixtureClient(statusCode: 503));
      final result = await GetHomeFeed(repo)();
      expect((result as ResultFailure).failure, isA<ServerFailure>());
    });

    test('fara conexiune -> NetworkFailure', () async {
      final repo = createHealthRepository(
          client: MockClient((_) => throw http.ClientException('offline')));
      final result = await GetAppointmentDetails(repo)();
      expect((result as ResultFailure).failure, isA<NetworkFailure>());
    });

    test('JSON invalid -> ParsingFailure', () async {
      final repo = createHealthRepository(
          client: MockClient((_) async => http.Response('not json', 200)));
      final result = await GetHomeFeed(repo)();
      expect((result as ResultFailure).failure, isA<ParsingFailure>());
    });
  });
}
