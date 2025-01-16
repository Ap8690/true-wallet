import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: CustomHomeAppbar(
            onBackTap: () => Navigator.of(context).pop(),
            centreText: 'Confirm',
            showTrailingWidget: false,
          )),
      body: Placeholder(),
    );
  }
}
