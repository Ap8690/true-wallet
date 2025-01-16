import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: CustomHomeAppbar(
            showBackWidget: false,
            onBackTap: () => Navigator.of(context).pop(),
            centreText: 'Send',
          )),
      body: Placeholder(),
    );
  }
}
