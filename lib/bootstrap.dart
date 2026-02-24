import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocket_commit/app/app.dart';
import 'firebase_options.dart';

/// Bootstrap function to initialize all services before the app starts
Future<void> bootstrap() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Pre-open the commits box so it's ready when needed
  await Hive.openBox<Map>('commits');

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Run the app with Riverpod
  runApp(const ProviderScope(child: PocketCommitApp()));
}
