import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdf_renderer/data/models/bookmark.dart';
import 'package:pdf_renderer/data/models/pdf_file.dart';
import 'package:pdf_renderer/data/models/pdf_repository.dart';
import 'package:meta/meta.dart';

part 'pdf_page_event.dart';
part 'pdf_page_state.dart';

class PDFPageBloc extends Bloc<PDFPageEvent, PDFPageState> {
  PDFRepository _pdfRepository = PDFRepository();
  List<Bookmark> _bookmarks = [];

  List<Bookmark> get bookmarks => _bookmarks;

  PDFPageBloc() : super(PDFPageInitial());

  @override
  Stream<PDFPageState> mapEventToState(
    PDFPageEvent event,
  ) async* {
    if (event is PDFPageLoadEvent) {
      File file;

      try {
        file = await _pdfRepository.loadFromLocalStorage(event.pdfFile);
        PDFFile pdfFile = event.pdfFile.copyWith(localPath: file.path);

        yield PDFPageLoaded(pdfFile);
      } catch (_) {}
    } else if (event is BookmarkAddEvent) {
      if (!isBookmarked(event.bookmark.page)) {
        _bookmarks.add(event.bookmark);
        event.onAdd();
      }
    } else if (event is BookmarkRemoveEvent) {
      if (isBookmarked(event.bookmark.page)) {
        _bookmarks.remove(event.bookmark);
        event.onRemove();
      }
    }
  }

  bool isBookmarked(int page) {
    return _bookmarks.contains(Bookmark(page: page));
  }
}
