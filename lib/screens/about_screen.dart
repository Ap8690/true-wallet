import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_gradient_text.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';

import '../constants/custom_color.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final Icon defaultTrailingIcon = const Icon(
    Icons.arrow_forward_ios,
    size: 30,
    color: CustomColor.grey,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: CustomHomeAppbar(
              showBackWidget: true,
              showTrailingWidget: true,
              onTrailingTap: () {},
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const CustomGradientText(
                        text: 'Settings',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: CustomColor.grey,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const CustomGradientText(
                      text: 'About',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              _buildListTile(context, 'Privacy Policy', () {},
                  trailingIcon: defaultTrailingIcon),
              _buildListTile(context, 'Term of Use', () {},
                  trailingIcon: defaultTrailingIcon),
              _buildListTile(context, 'Attribution', () {},
                  trailingIcon: defaultTrailingIcon),
              _buildListTile(context, 'Visit Our Support Center', () {},
                  trailingIcon: defaultTrailingIcon),
              _buildListTile(context, 'Visit Website', () {},
                  trailingIcon: defaultTrailingIcon),
              _buildListTile(context, 'Contact Us', () {},
                  trailingIcon: defaultTrailingIcon),
            ],
          ),
        ));
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
