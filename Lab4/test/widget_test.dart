import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab4/domain/repositories/health_repository.dart';
import 'package:lab4/domain/usecases/get_home_feed.dart';
import 'package:lab4/main.dart';
import 'package:lab4/presentation/cubits/home/home_cubit.dart';
import 'package:lab4/presentation/widgets/health_service_item.dart';

import 'helpers.dart';

HomeCubit homeCubit([HealthRepository? repo]) => HomeCubit(GetHomeFeed(repo ?? fakeApiRepository()));

void main() {
  setUpAll(() => HealthServiceItem.loadNetworkIcons = false);

  group('HomeCubit', () {
    test('loads data -> Success', () async {
      final cubit = homeCubit();
      await cubit.loadData();
      expect(cubit.state, isA<HomeSuccess>());
      expect((cubit.state as HomeReady).visibleDoctors, isNotEmpty);
    });

    test('error -> Error', () async {
      final cubit = homeCubit(FailingRepository());
      await cubit.loadData();
      expect(cubit.state, isA<HomeError>());
    });

    test('search with no results -> Empty, clear -> Success', () async {
      final cubit = homeCubit();
      await cubit.loadData();
      cubit.search('zzzz');
      expect(cubit.state, isA<HomeEmpty>());
      cubit.clearFilters();
      expect(cubit.state, isA<HomeSuccess>());
    });

    test('filter, sort and favorites', () async {
      final cubit = homeCubit();
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
    await tester.pumpWidget(MyApp(repository: fakeApiRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(find.text('Health Services'), findsOneWidget);

    await tester.tap(find.text('Dr. Richar Kandowen'));
    await tester.pumpAndSettle();

    expect(find.text('Book an Appointment'), findsOneWidget);
    expect(find.text('Dr.Upul'), findsOneWidget);
  });

  testWidgets('Search shows Empty state', (tester) async {
    await tester.pumpWidget(MyApp(repository: fakeApiRepository()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'nobody-here');
    await tester.pump();
    expect(find.text('No doctors found'), findsOneWidget);
  });

  testWidgets('Home shows Error when API fails', (tester) async {
    await tester.pumpWidget(MyApp(repository: FailingRepository()));
    await tester.pumpAndSettle();
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('Appointment screen shows Error when details fail',
      (tester) async {
    await tester.pumpWidget(MyApp(repository: DetailsFailingRepository()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dr. Richar Kandowen'));
    await tester.pumpAndSettle();
    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('Book an Appointment'), findsNothing);
  });
}
