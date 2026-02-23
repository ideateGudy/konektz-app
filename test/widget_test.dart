import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:konektz/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:konektz/features/auth/data/repositories/auth_repository_implementation.dart';
import 'package:konektz/main.dart';

void main() {
  testWidgets('App smoke test - renders without crashing', (
    WidgetTester tester,
  ) async {
    final authRepository = AuthRepositoryImplementation(
      authRemoteDatasource: AuthRemoteDatasourceImpl(),
    );
    await tester.pumpWidget(MyApp(authRepository: authRepository));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
