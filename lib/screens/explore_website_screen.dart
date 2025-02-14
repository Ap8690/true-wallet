import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';
import 'package:flutter_application_1/components/custom_text.dart';

class ExploreWebsiteScreen extends StatefulWidget {
  const ExploreWebsiteScreen({super.key});

  @override
  State<ExploreWebsiteScreen> createState() => _ExploreWebsiteScreenState();
}

class _ExploreWebsiteScreenState extends State<ExploreWebsiteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CustomHomeAppbar(
          showBackWidget: true,
          showTrailingWidget: true,
          onTrailingTap: () {},
        ),
      ),
      body: Center(
        child: CustomText(
          text: 'Welcome to the Website',
        ),
      ),
    );
  }
}
