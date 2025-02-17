import "package:flutter/material.dart";

customBottomSheet(
    BuildContext context, Widget Function(ScrollController) widget,
    {double minHeight = 0.5}) async {
  await showModalBottomSheet<String>(
    enableDrag: true,
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    scrollControlDisabledMaxHeightRatio: 0,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) => DraggableScrollableSheet(
      expand: false,
      minChildSize: minHeight,
      initialChildSize: minHeight,
      builder: (context, scrollController) => Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: widget(scrollController),
      ),
    ),
  );
}
