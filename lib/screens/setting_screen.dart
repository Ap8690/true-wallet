import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_gradient_text.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';
import 'package:flutter_application_1/screens/connect_wallet_screen.dart';
import 'package:flutter_application_1/screens/export_private_key_screen.dart';
import '../constants/custom_color.dart';
import 'about_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final Icon defaultTrailingIcon = const Icon(
    Icons.arrow_forward_ios,
    size: 30,
    color: CustomColor.grey,
  );

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CustomGradientText(
                text: 'Settings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 60),
            _buildListTile(context, 'About', () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AboutScreen()));
            }),
            _buildListTile(
              context,
              'Request a Feature',
              () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ConnectWalletScreen()));
              },
              trailingIcon: defaultTrailingIcon,
            ),
            _buildListTile(
              context,
              'Export Private Key',
              () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ExportPrivateKeyScreen()));
              },
              trailingIcon: defaultTrailingIcon,
            ),
            _buildListTile(
              context,
              'Contact Support',
              () {},
              trailingIcon: defaultTrailingIcon,
            ),
            _buildListTile(
              context,
              'Lock',
              () {},
              trailingIcon: defaultTrailingIcon,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String label, Function() onTap,
      {Icon? trailingIcon}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: CustomColor.offWhite,
        border: Border.all(color: CustomColor.whiteLight),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        title: Text(label),
        onTap: onTap,
        trailing: trailingIcon,
      ),
    );
  }
}
