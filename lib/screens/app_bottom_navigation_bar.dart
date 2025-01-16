import 'package:flutter/material.dart';

import '../constants/custom_color.dart';
import '../constants/image_path.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final ValueChanged<int> onItemTapped;
  final int currentIndex;

  const AppBottomNavigationBar({
    super.key,
    required this.onItemTapped,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 68,
      notchMargin: 0,
      color: CustomColor.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _buildNavItem(
              iconPath: ImagePath.homeIcon,
              iconPathSelected: ImagePath.homeIconGradient,
              index: 0,
            ),
          ),
          Expanded(
            child: _buildNavItem(
              iconPath: ImagePath.transactionGrey,
              iconPathSelected: ImagePath.transactionGradient,
              index: 1,
            ),
          ),
          Expanded(
            child: _buildNavItem(
              iconPath: ImagePath.sendReceiveGrey,
              iconPathSelected: ImagePath.sendReceiveGradient,
              index: 2,
              fontSize: 12,
            ),
          ),
          Expanded(
            child: _buildNavItem(
              iconPath: ImagePath.compassGrey,
              iconPathSelected: ImagePath.compassGradient,
              index: 3,
            ),
          ),
          Expanded(
            child: _buildNavItem(
              iconPath: ImagePath.settingGrey,
              iconPathSelected: ImagePath.settingGradient,
              index: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required String iconPathSelected,
    required int index,
    double? fontSize,
  }) {
    bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: EdgeInsets.only(bottom: isSelected ? 8 : 0),
            child: Image.asset(
              isSelected ? iconPathSelected : iconPath,
              height: isSelected ? 28 : 24,
              width: isSelected ? 28 : 24,
            ),
          ),
          if (isSelected)
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: CustomColor.blue,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
