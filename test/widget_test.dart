// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:evergreenix_flutter_task/main.dart';
import 'package:evergreenix_flutter_task/core/network/api_client.dart';
import 'package:evergreenix_flutter_task/reposatories/auth_repository.dart';
import 'package:evergreenix_flutter_task/core/constants/api_endpoints.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Create required dependencies
    final apiClient = ApiClient(baseUrl: ApiEndpoints.baseUrl);
    final authRepository = AuthRepository(apiClient);
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(authRepository: authRepository));

    // Verify that the app loads without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
