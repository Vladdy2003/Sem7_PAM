import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab3/cubits/home/home_cubit.dart';
import 'package:lab3/data/health_repository.dart';
import 'package:lab3/main.dart';
import 'package:lab3/models/app_data.dart';
import 'package:lab3/widgets/health_service_item.dart';

// Repository fals: citeste acelasi lab.json, sincron, fara intarziere
class FakeRepository implements HealthRepository {
  @override
  Future<AppData> loadAppData() async {
    final raw = File('assets/data/lab.json').readAsStringSync();
    return AppData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}

class FailingRepository implements HealthRepository {
  @override
  Future<AppData> loadAppData() async => throw Exception('boom');
}

void main() {
  setUpAll(() => HealthServiceItem.loadNetworkIcons = false);

  group('HomeCubit', () {
    test('loads data -> Success', () async {
      final cubit = HomeCubit(FakeRepository());
      await cubit.loadData();
      expect(cubit.state, isA<HomeSuccess>());
      expect((cubit.state as HomeReady).visibleDoctors, isNotEmpty);
    });

    test('error -> Error', () async {
      final cubit = HomeCubit(FailingRepository());
      await cubit.loadData();
      expect(cubit.state, isA<HomeError>());
    });

    test('search with no results -> Empty, clear -> Success', () async {
      final cubit = HomeCubit(FakeRepository());
      await cubit.loadData();
      cubit.search('zzzz');
      expect(cubit.state, isA<HomeEmpty>());
      cubit.clearFilters();
      expect(cubit.state, isA<HomeSuccess>());
    });

    test('filter, sort and favorites', () async {
      final cubit = HomeCubit(FakeRepository());
      await cubit.loadData();

      cubit.selectSpecialty('Dental Specialist');
      var s = cubit.state as HomeReady;
      expect(s.visibleDoctors.every((d) => d.specialty == 'Dental Specialist'),
          isTrue);

      cubit.selectSpecialty(null);
      cubit.changeSort(DoctorSort.distance);
      s = cubit.state as HomeReady;
      final meters = s.visibleDoctors.map((d) => d.distanceMeters).toList();
      expect(meters, [...meters]..sort());

      cubit.toggleFavorite('doctor-001');
      cubit.setFavoritesOnly(true);
      s = cubit.state as HomeReady;
      expect(s.visibleDoctors.map((d) => d.id), contains('doctor-001'));
      expect(s.visibleDoctors.every((d) => d.isFavorite), isTrue);
    });
  });


  testWidgets('Home screen opens Appointment screen', (tester) async {
    await tester.pumpWidget(MyApp(repository: FakeRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(find.text('Health Services'), findsOneWidget);

    await tester.tap(find.text('Dr. Richar Kandowen'));
    await tester.pumpAndSettle();

    expect(find.text('Book an Appointment'), findsOneWidget);
    expect(find.text('Dr.Upul'), findsOneWidget);
  });

  testWidgets('Search shows Empty state', (tester) async {
    await tester.pumpWidget(MyApp(repository: FakeRepository()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'nobody-here');
    await tester.pump();
    expect(find.text('No doctors found'), findsOneWidget);
  });
}
