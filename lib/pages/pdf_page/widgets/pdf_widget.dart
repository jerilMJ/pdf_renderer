import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';

import '../../../utils/custom_gesture_recognizers.dart';
import '../providers/pdf_page_state_provider/pdf_page_state_provider.dart';

class PDFWidget extends StatelessWidget {
  const PDFWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PDFPageStateProvider>(
      builder: (_, provider, __) => PDFView(
        key: provider.pdfViewerKey,
        defaultPage: provider.currentPage,
        filePath: provider.pdfFile.localFilePath,
        enableSwipe: true,
        swipeHorizontal: provider.swipeHorizontal,
        autoSpacing: provider.autoSpacing,
        pageFling: provider.pageFling,
        pageSnap: true,
        fitEachPage: true,
        fitPolicy: FitPolicy.BOTH,
        nightMode: provider.nightMode,
        gestureRecognizers: Set()
          ..add(
            Factory<CustomTapGestureRecognizer>(
              () => CustomTapGestureRecognizer()..onTap = provider.onTapPDF,
            ),
          ),
        onRender: provider.onRender,
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
        onViewCreated: provider.onViewCreated,
        onPageChanged: provider.onPageChanged,
      ),
    );
  }
}
