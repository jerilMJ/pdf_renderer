import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:pdf_renderer/data/models/pdf_file.dart';
import 'package:pdf_renderer/utils/exceptions.dart';
import 'package:printing/printing.dart';

class PDFRepository {
  const PDFRepository();

  Future<File> loadFromLocalStorage(PDFFile pdfFile) async {
    Completer<File> completer = Completer();
    try {
      var dir = await pathProvider.getApplicationDocumentsDirectory();
      File file = File(
        '${dir.path}/${pdfFile.localFilePath ?? pdfFile.fileURL.replaceFirst('documents/', '')}',
      );

      if (file.existsSync()) {
        completer.complete(file);
        return completer.future;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw PDFLocalFetchException();
    }
  }

  Future<Uint8List> getImageOfFirstPage(PDFFile pdfFile) async {
    Uint8List img;
    try {
      var dir = await pathProvider.getApplicationDocumentsDirectory();
      File file = File(
        '${dir.path}/${pdfFile.localFilePath ?? pdfFile.fileURL.replaceFirst('documents/', '')}',
      );

      if (file.existsSync()) {
        var data = file.readAsBytesSync();
        await for (var page in Printing.raster(data)) {
          img = await page.toPng();
          break;
        }
      } else {
        throw Exception();
      }
    } catch (e) {
      throw PDFLocalFetchException();
    }
    return img;
  }
}
