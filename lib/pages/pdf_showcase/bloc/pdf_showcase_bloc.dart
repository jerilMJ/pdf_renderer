import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdf_renderer/data/models/pdf_file.dart';
import 'package:pdf_renderer/data/models/pdf_repository.dart';
import 'package:pdf_renderer/pages/pdf_page/bloc/pdf_page_bloc.dart';

part 'pdf_showcase_event.dart';
part 'pdf_showcase_state.dart';

class PDFShowcaseBloc extends Bloc<PDFShowcaseEvent, PDFShowcaseState> {
  PDFShowcaseBloc() : super(PdfShowcaseInitial());

  PDFRepository pdfRepository = PDFRepository();

  @override
  Stream<PDFShowcaseState> mapEventToState(
    PDFShowcaseEvent event,
  ) async* {}

  Future<Uint8List> getPDFCover(PDFFile pdfFile) {
    return pdfRepository.getImageOfFirstPage(pdfFile);
  }
}
