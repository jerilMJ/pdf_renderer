import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf_renderer/data/models/bookmark.dart';
import 'package:pdf_renderer/data/models/pdf_file.dart';
import 'package:pdf_renderer/data/models/pdf_nav_state.dart';
import 'package:pdf_renderer/data/models/pdf_viewer_option.dart';
import 'package:pdf_renderer/pages/pdf_page/bloc/pdf_page_bloc.dart';
import 'package:pdf_renderer/pages/pdf_page/pdf_page.dart';

part 'pdf_page_accessibility_options.dart';
part 'pdf_page_animations.dart';

class PDFPageStateProvider extends ChangeNotifier
    with PDFViewAnimations, PDFPageAccessibilityOptions {
  PDFPageStateProvider(PDFFile file) : _pdfFile = file;

  PDFFile _pdfFile;
  PDFViewController _pdfViewController;
  Key _pdfViewerKey = UniqueKey();
  ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  ValueNotifier<double> _sliderVal = ValueNotifier(0.0);
  int _totalPages;

  ValueNotifier<int> get currentPageNotifier => _currentPage;
  UniqueKey get pdfViewerKey => _pdfViewerKey;
  ValueNotifier<double> get sliderVal => _sliderVal;
  int get currentPage => _currentPage.value;
  int get totalPages => _totalPages;
  Animation<double> get navBarSlideAnimController => _navBarSlideAnimController;
  PDFFile get pdfFile => _pdfFile;

  @override
  void notifyListeners() {
    if (swipeHorizontal) {
      navBarAnim = Tween(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
          .animate(_navBarSlideAnimController);
    } else {
      navBarAnim = Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
          .animate(_navBarSlideAnimController);
    }
    super.notifyListeners();
  }

  void _setState(Function function) async {
    await function();
    notifyListeners();
  }

  void reRender() {
    _setState(() async {
      await Future.delayed(Duration(milliseconds: 250), () {
        _pdfViewerKey = UniqueKey();
      });
    });
  }

  void onRender(int totalPages) {
    _setState(() {
      _totalPages = totalPages;
    });
  }

  void goToPage(int page) {
    _pdfViewController.setPage(page);
  }

  void onPageChanged(int page, int total) {
    _currentPage.value = page;
    _sliderVal.value = (page + 1) / total;
    if (page == 0) _sliderVal.value = 0.0;
    _dragStream.sink.add(PDFNavState.dragging);
  }

  void onViewCreated(PDFViewController controller) {
    _pdfViewController = controller..setPage(_currentPage.value);
  }

  void sliderOnChanged(double value) {
    _sliderVal.value = value;
    _currentPage.value =
        (value * (totalPages - 1)).round().clamp(0, totalPages - 1);
    _pdfViewController.setPage(currentPage);
  }

  void sliderOnPointerDown(PointerDownEvent _) {
    _dragStream.sink.add(PDFNavState.scrollbarHeld);
  }

  void sliderOnPointerUp(PointerUpEvent _) {
    _dragStream.sink.add(PDFNavState.scrollbarLetGo);
  }

  void onSelectedOption(PDFViewerOption option, BuildContext context) {
    if (executeOption(option, context, currentPage)) {
      _setState(() {
        _pdfViewerKey = UniqueKey();
      });
    }
  }

  @override
  void dispose() {
    _navHideTimer?.cancel();
    _dragStream.close();
    super.dispose();
  }
}
