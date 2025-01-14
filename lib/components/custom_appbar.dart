import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/constants/image_path.dart';

class CustomAppbar extends StatelessWidget {
  final bool showCenterWidget;
  final bool showBackWidget;
  final bool showProgressBars;
  final VoidCallback? onBackArrowTap;
  final List<bool>? progressStatuses;
  final double? toolBarHeight;

  const CustomAppbar({
    super.key,
    this.showCenterWidget = false,
    this.showBackWidget = false,
    this.showProgressBars = false,
    this.onBackArrowTap,
    this.progressStatuses,
    this.toolBarHeight,
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showCenterWidget) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 10),
                  _buildCenterWidget(context),
                  const SizedBox(width: 10),
                ],
              ),
            ],
            if (showBackWidget) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBackWidget(),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              )
            ],
            if (showProgressBars && progressStatuses != null) ...[
              const SizedBox(height: 8),
              _buildProgressBars(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCenterWidget(BuildContext context) {
    return Image.asset(
      ImagePath.trueWallet,
      height: 60,
      width: MediaQuery.of(context).size.width * 2 / 3,
      fit: BoxFit.contain,
    );
  }

  Widget _buildBackWidget() {
    return GestureDetector(
      onTap: onBackArrowTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            ImagePath.backArrow,
            height: 30,
            width: 30,
          ),
          const SizedBox(width: 20),
          const Text(
            'Back',
            style: TextStyle(
              color: CustomColor.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBars(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(
          progressStatuses!.length,
          (index) => _buildProgressBar(progressStatuses![index],
              MediaQuery.of(context).size.width * 1 / 3 - 32),
        ),
      ),
    );
  }

  Widget _buildProgressBar(bool isActive, double width) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: width,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        gradient: isActive
            ? const LinearGradient(
                colors: [Colors.green, Colors.blue],
              )
            : const LinearGradient(
                colors: [Colors.grey, Colors.grey],
              ),
      ),
    );
  }
}
