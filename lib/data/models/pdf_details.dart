import 'package:meta/meta.dart';
import 'package:pdf_renderer/data/models/pdf_file.dart';

class PDFDetails {
  const PDFDetails({
    @required this.title,
    @required this.uploader,
    @required this.pdfFile,
    @required this.uploadedDate,
  }) : modifiedDate = uploadedDate;

  final String title;
  final String uploader;
  final PDFFile pdfFile;
  final DateTime uploadedDate;
  final DateTime modifiedDate;
}
