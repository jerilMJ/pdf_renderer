import 'package:flutter/material.dart';

enum PDFViewerOption {
  organizeHorizontal,
  organizeVertical,
  condensePages,
  expandPages,
  scrollContinuous,
  scrollPageByPage,
  toggleBookmark,
  manageBookmarks,
  nightMode,
  lightMode,
}

class PDFViewerOptionContent {
  PDFViewerOptionContent({
    @required this.title,
    @required this.icon,
  });

  Icon icon;
  String title;
}
