part of 'pdf_page_bloc.dart';

abstract class PDFPageEvent extends Equatable {
  const PDFPageEvent();
}

class PDFPageLoadEvent extends PDFPageEvent {
  const PDFPageLoadEvent(this.pdfFile);

  final PDFFile pdfFile;

  @override
  List<Object> get props => [pdfFile];
}

class BookmarkAddEvent extends PDFPageEvent {
  const BookmarkAddEvent({
    @required this.bookmark,
    this.onAdd,
  });

  final Bookmark bookmark;
  final Function onAdd;

  @override
  List<Object> get props => [bookmark];
}

class BookmarkRemoveEvent extends PDFPageEvent {
  const BookmarkRemoveEvent({
    @required this.bookmark,
    this.onRemove,
  });

  final Bookmark bookmark;
  final Function onRemove;

  @override
  List<Object> get props => [bookmark];
}
