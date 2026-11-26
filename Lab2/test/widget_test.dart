import 'package:flutter_test/flutter_test.dart';

import 'package:lab2/main.dart';

void main() {
  testWidgets('Home screen opens Appointment screen', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(find.text('Health Services'), findsOneWidget);

    await tester.tap(find.text('Dr. Richar Kandowen'));
    await tester.pumpAndSettle();

    expect(find.text('Book an Appointment'), findsOneWidget);
    expect(find.text('Dr.Upul'), findsOneWidget);
  });
}
