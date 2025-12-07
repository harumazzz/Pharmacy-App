import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/data/local/mock_data_service.dart';
import 'package:pharmacy_app/di/injection.dart';
import 'package:pharmacy_app/presentation/screens/auth/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  //await _loadMockData();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _loadMockData() async {
  try {
    final mockDataService = getIt<MockDataService>();
    await mockDataService.insertMockData();
  } catch (e) {
    debugPrint('Error loading mock data: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Pharmacy App', home: AuthWrapper());
  }
}
