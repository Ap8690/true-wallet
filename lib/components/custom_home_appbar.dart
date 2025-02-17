import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_gradient_text.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/constants/image_path.dart';
import 'package:flutter_application_1/screens/chain_selection_widget.dart';

import 'custom_text.dart';
import 'custom_text_styles.dart';

class CustomHomeAppbar extends StatelessWidget {
  final bool showBackWidget;
  final bool showTrailingWidget;
  final double? toolBarHeight;
  final VoidCallback? onTrailingTap;
  final VoidCallback? onBackTap;
  final String? centreText;
  final String? centreAsset;
  final double? centreAssetSize;

  const CustomHomeAppbar({
    super.key,
    this.showBackWidget = false,
    this.showTrailingWidget = false,
    this.toolBarHeight,
    this.onTrailingTap,
    this.onBackTap,
    this.centreText,
    this.centreAsset,
    this.centreAssetSize,
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
        ? ChainSelectionWidget()
        : const SizedBox(
            width: 10,
          );
  }

  Widget _buildCentreWidget() {
    if (centreAsset != null) {
      return Image.asset(
        centreAsset!,
        height: centreAssetSize ?? 50,
        width: 120,
      );
    }
    return CustomGradientText(
      text: centreText,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
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
              child: const SizedBox(
                height: 30,
                width: 30,
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: CustomColor.green,
                  ),
                ),
              ),
            ),
          );
  }
}
