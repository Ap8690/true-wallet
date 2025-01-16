import 'package:flutter/material.dart';

class CustomGradientIndicator extends Decoration {
  final LinearGradient gradient;
  final double height;
  final double screenWidth;

  CustomGradientIndicator({
    required this.gradient,
    this.height = 4.0,
    required this.screenWidth,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _GradientPainter(gradient, height, screenWidth);
  }
}

class _GradientPainter extends BoxPainter {
  final LinearGradient gradient;
  final double height;
  final double screenWidth;

  _GradientPainter(this.gradient, this.height, this.screenWidth);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(
          0,
          0,
          configuration.size!.width,
          configuration.size!.height,
        ),
      )
      ..style = PaintingStyle.fill;

    final double indicatorWidth = screenWidth / 2;

    final double startX =
        offset.dx + (configuration.size!.width - indicatorWidth) / 2;

    final Rect rect = Rect.fromLTWH(
      startX,
      configuration.size!.height - height,
      indicatorWidth,
      height,
    );

    canvas.drawRect(rect, paint);
  }
}
