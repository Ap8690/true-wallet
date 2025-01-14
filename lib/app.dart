import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/screens/onboarding_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrueWallet',
      theme: ThemeData(
          colorScheme: const ColorScheme.light(onPrimary: CustomColor.white)),
      home: OnboardingScreen(),
    );
  }
}
