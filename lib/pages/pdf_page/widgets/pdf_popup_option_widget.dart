import 'package:flutter/material.dart';

import '../../../data/models/pdf_viewer_option.dart';

typedef void PDFViewerOptionFunction(PDFViewerOption option);

class PDFPopupOptionWidget extends StatelessWidget {
  const PDFPopupOptionWidget({
    Key key,
    this.icon,
    this.tooltip,
    @required this.items,
    @required this.onSelected,
  }) : super(key: key);

  final Map<PDFViewerOption, PDFViewerOptionContent> items;
  final PDFViewerOptionFunction onSelected;
  final Icon icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PDFViewerOption>(
      tooltip: tooltip,
      icon: icon,
      itemBuilder: (_) {
        return items
            .map((option, content) {
              return MapEntry(
                option,
                PopupMenuItem(
                  value: option,
                  child: ListTile(
                    leading: content.icon,
                    title: Text(content.title),
                  ),
                ),
              );
            })
            .values
            .toList();
      },
      onSelected: onSelected,
    );
  }
}
