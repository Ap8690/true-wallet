
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CustomLoader {
  static show(BuildContext context, {String? message}) {
    context.loaderOverlay.hide();
    context.loaderOverlay.show(
      widgetBuilder: (progress) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
           const SizedBox(
              height: 5,
            ),
            Text(
              message,
              style: const TextStyle(color: Colors.white),
            )
          ]
        ],
      ),
    );
  }

  static hide(BuildContext context) {
    context.loaderOverlay.hide();
  }
}
