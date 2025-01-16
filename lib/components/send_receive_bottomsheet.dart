import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/image_path.dart';

import '../constants/custom_color.dart';
import 'custom_gradient_text.dart';

class SendReceiveBottomsheet {
  static show(
    BuildContext context,
    String title,
    List<Map<String, String>> items,
    Function(String) onItemSelected,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.35,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomGradientText(
                      text: title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: Center(
                        child: Column(children: [
                          const SizedBox(
                            height: 20,
                          ),
                          _buildListTile(context, ImagePath.compassGradient,
                              'Send Token', () {}),
                          const SizedBox(
                            height: 10,
                          ),
                          _buildListTile(context, ImagePath.settingGradient,
                              'Receive Token', () {}),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildListTile(
      BuildContext context, String iconPath, String label, Function() onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: CustomColor.offWhite),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        leading: Image.asset(iconPath, width: 24, height: 24),
        title: Text(label),
        onTap: onTap,
      ),
    );
  }
}
