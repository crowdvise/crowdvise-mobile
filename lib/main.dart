import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/core/presentation/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: "assets/config/.env");
  configureDependencies();
  runApp(const CrowdViseApp());
}
