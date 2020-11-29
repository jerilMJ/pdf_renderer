import 'package:flutter/material.dart';

import 'bookmark.dart';

class PDFViewSettingsStore {
  static final Map<BookmarkType, String> bookmarkTypeTitle = {
    BookmarkType.formula: 'Formula',
    BookmarkType.note: 'Note',
    BookmarkType.normal: 'Normal',
    BookmarkType.other: 'Other',
    BookmarkType.exam: 'Exam',
  };

  static final Map<BookmarkType, IconData> bookmarkTypeIcon = {
    BookmarkType.formula: Icons.functions,
    BookmarkType.note: Icons.note,
    BookmarkType.normal: Icons.bookmark,
    BookmarkType.other: Icons.info,
    BookmarkType.exam: Icons.playlist_add_check,
  };
}
