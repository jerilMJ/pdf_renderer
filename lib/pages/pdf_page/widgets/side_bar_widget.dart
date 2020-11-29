import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_renderer/pages/pdf_page/bloc/pdf_page_bloc.dart';
import 'package:provider/provider.dart';

import '../../../data/models/pdf_viewer_option.dart';
import '../pdf_page.dart';
import '../providers/pdf_page_state_provider/pdf_page_state_provider.dart';
import 'pdf_popup_option_widget.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PDFPageStateProvider>(
      builder: (_, provider, __) => Positioned(
        top: 0.0,
        left: 0.0,
        child: SlideTransition(
          position: provider.appBarAnim,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10.0),
              ),
              color: Colors.blue.shade300,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PDFPopupOptionWidget(
                  tooltip: 'Page Organization',
                  icon: Icon(Icons.view_carousel),
                  items: {
                    PDFViewerOption.organizeHorizontal: PDFViewerOptionContent(
                      title: 'Organize Horizontally',
                      icon: Icon(Icons.view_array),
                    ),
                    PDFViewerOption.organizeVertical: PDFViewerOptionContent(
                      title: 'Organize Vertically',
                      icon: Icon(Icons.view_day),
                    ),
                  },
                  onSelected: (option) =>
                      provider.onSelectedOption(option, context),
                ),
                PDFPopupOptionWidget(
                  tooltip: 'Page Sizing',
                  icon: Icon(Icons.pages),
                  items: {
                    PDFViewerOption.condensePages: PDFViewerOptionContent(
                      title: 'Condense Pages',
                      icon: Icon(Icons.fullscreen_exit),
                    ),
                    PDFViewerOption.expandPages: PDFViewerOptionContent(
                      title: 'Expand Pages',
                      icon: Icon(Icons.fullscreen),
                    ),
                  },
                  onSelected: (option) =>
                      provider.onSelectedOption(option, context),
                ),
                PDFPopupOptionWidget(
                  tooltip: 'Scroll Options',
                  icon: Icon(Icons.touch_app),
                  items: {
                    PDFViewerOption.scrollContinuous: PDFViewerOptionContent(
                      title: 'Continuous Scroll',
                      icon: provider.swipeHorizontal
                          ? Icon(Icons.arrow_forward)
                          : Icon(Icons.arrow_downward),
                    ),
                    PDFViewerOption.scrollPageByPage: PDFViewerOptionContent(
                      title: 'Page-by-page Scroll',
                      icon: provider.swipeHorizontal
                          ? Icon(Icons.arrow_right)
                          : Icon(Icons.arrow_drop_down),
                    ),
                  },
                  onSelected: (option) =>
                      provider.onSelectedOption(option, context),
                ),
                ValueListenableBuilder(
                  valueListenable: provider.currentPageNotifier,
                  builder: (context, page, __) {
                    final bool isBookmarked =
                        BlocProvider.of<PDFPageBloc>(context)
                            .isBookmarked(page);

                    return IconButton(
                      tooltip: isBookmarked ? 'Bookmarked' : 'Not Bookmarked',
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      ),
                      onPressed: () => provider.onSelectedOption(
                        PDFViewerOption.toggleBookmark,
                        context,
                      ),
                    );
                  },
                ),
                PDFPopupOptionWidget(
                  tooltip: 'Other Options',
                  items: {
                    PDFViewerOption.manageBookmarks: PDFViewerOptionContent(
                      title: 'Manage Bookmarks',
                      icon: Icon(Icons.collections_bookmark),
                    ),
                    PDFViewerOption.nightMode: PDFViewerOptionContent(
                      title: 'Night Mode',
                      icon: Icon(Icons.brightness_3),
                    ),
                    PDFViewerOption.lightMode: PDFViewerOptionContent(
                      title: 'Light Mode',
                      icon: Icon(Icons.brightness_7),
                    ),
                  },
                  onSelected: (option) =>
                      provider.onSelectedOption(option, context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
