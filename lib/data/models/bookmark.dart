import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum BookmarkType {
  formula,
  note,
  normal,
  other,
  exam,
}

class Bookmark extends Equatable {
  Bookmark({
    @required this.page,
    this.title,
    this.description,
    this.type = BookmarkType.normal,
  }) : createdOn = DateTime.now();

  final int page;
  final String title;
  final String description;
  final DateTime createdOn;
  final BookmarkType type;

  @override
  List<Object> get props => [page];

  @override
  String toString() {
    return 'Page $page: $title';
  }
}
