// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:linkedin_interpol/main.dart';
import 'package:linkedin_interpol/services/storage_service.dart';
import 'package:linkedin_interpol/services/data_service.dart';
import 'package:linkedin_interpol/repositories/profile_repository.dart';
import 'package:linkedin_interpol/repositories/statistics_repository.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final storageService = StorageService();
    final dataService = DataService();
    final profileRepository = ProfileRepository(dataService);
    final statisticsRepository = StatisticsRepository(storageService);

    await tester.pumpWidget(MyApp(
      storageService: storageService,
      profileRepository: profileRepository,
      statisticsRepository: statisticsRepository,
    ));

    // Verify that the home screen loads
    expect(find.text('LinkedIn ou Interpol'), findsOneWidget);
  });
}
