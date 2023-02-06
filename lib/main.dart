import 'package:flutter/material.dart';
import 'package:hello_app/app/app.locator.dart';
import 'package:hello_app/app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const MyApp());
}


