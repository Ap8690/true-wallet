import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_gradient_text.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/constants/image_path.dart';

import 'custom_text.dart';
import 'custom_text_styles.dart';

class CustomHomeAppbar extends StatelessWidget {
  final bool showBackWidget;
  final bool showTrailingWidget;
  final double? toolBarHeight;
  final VoidCallback? onTrailingTap;
  final VoidCallback? onBackTap;
  final String? centreText;

  const CustomHomeAppbar({
    super.key,
    this.showBackWidget = false,
    this.showTrailingWidget = false,
    this.toolBarHeight,
    this.onTrailingTap,
    this.onBackTap,
    this.centreText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: toolBarHeight ?? 80,
        backgroundColor: CustomColor.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBackWidget(),
            _buildCentreWidget(),
            _buildTrailingWidget()
          ],
        ),
      ),
    );
  }

  Widget _buildTrailingWidget() {
    return showTrailingWidget
        ? GestureDetector(
            onTap: onTrailingTap,
            child: Container(
              width: 100,
              height: 38,
              decoration: BoxDecoration(
                color: CustomColor.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomText(
                    text: 'BlockFit',
                    style: CustomTextStyles.textCommon(
                      color: CustomColor.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Transform.rotate(
                    angle: 90 * (3.14 / 180),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: CustomColor.offWhite,
                    ),
                  )
                ],
              ),
            ),
          )
        : const SizedBox(
            width: 10,
          );
  }

  Widget _buildCentreWidget() {
    return CustomGradientText(
        text: centreText,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
  }

  Widget _buildBackWidget() {
    return showBackWidget
        ? Image.asset(
            ImagePath.trueWallet,
            height: 50,
            width: 120,
          )
        : GestureDetector(
            onTap: onBackTap,
            child: Transform.rotate(
              angle: 180 * (3.14 / 180),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: CustomColor.green,
              ),
            ),
          );
  }
}
