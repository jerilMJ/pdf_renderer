part of 'pdf_page_bloc.dart';

abstract class PDFPageState extends Equatable {
  const PDFPageState();
}

class PDFPageInitial extends PDFPageState {
  @override
  List<Object> get props => [];
}

class PDFPageLoading extends PDFPageState {
  PDFPageLoading(this.fileURL);

  final String fileURL;

  @override
  List<Object> get props => [];
}

class PDFPageLoaded extends PDFPageState {
  PDFPageLoaded(this.pdfFile);

  final PDFFile pdfFile;

  @override
  List<Object> get props => [];
}

class PDFPageError extends PDFPageState {
  PDFPageError({this.fileURL, this.error});

  final String fileURL;
  final Object error;

  @override
  List<Object> get props => [];
}
