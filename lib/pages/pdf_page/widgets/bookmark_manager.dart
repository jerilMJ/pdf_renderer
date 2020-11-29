import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_renderer/data/models/bookmark.dart';
import 'package:pdf_renderer/data/models/pdf_view_settings_store.dart';
import 'package:pdf_renderer/pages/pdf_page/bloc/pdf_page_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pdf_renderer/pages/pdf_page/providers/pdf_page_state_provider/pdf_page_state_provider.dart';
import 'package:provider/provider.dart';

import '../pdf_page.dart';

class BookmarkManager extends StatefulWidget {
  const BookmarkManager({
    Key key,
    this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  _BookmarkManagerState createState() => _BookmarkManagerState();
}

class _BookmarkManagerState extends State<BookmarkManager> {
  PDFPageBloc _pdfPageBloc;
  PDFPageStateProvider _provider;

  @override
  void initState() {
    super.initState();
    _pdfPageBloc = BlocProvider.of<PDFPageBloc>(widget.context);
    _provider =
        Provider.of<PDFPageStateProvider>(widget.context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (_pdfPageBloc.bookmarks.isEmpty) {
      child = Text('You don\'t have any bookmarks for this note yet.');
    } else {
      child = ListView.builder(
        itemCount: _pdfPageBloc.bookmarks.length,
        itemBuilder: (context, index) {
          Bookmark bookmark = _pdfPageBloc.bookmarks[index];
          return GestureDetector(
            onTap: () {
              _provider.goToPage(bookmark.page);
              Navigator.of(context).maybePop();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Icon(
                        PDFViewSettingsStore.bookmarkTypeIcon[bookmark.type],
                      ),
                    ),
                    Expanded(child: Text('Page ${bookmark.page + 1}')),
                    Expanded(
                      child: Text(
                        '${DateFormat('dd MMM yyyy').format(bookmark.createdOn)}',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.38),
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            PDFPage.of(widget.context)
                                .buildRemoveBookmarkDialog(
                              widget.context,
                              bookmark,
                              onRemove: () => setState(() {}),
                            );
                          }),
                    ),
                  ],
                ),
                Text('${bookmark.description}'),
              ],
            ),
          );
        },
      );
    }

    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        padding: const EdgeInsets.all(20.0),
        child: child,
      ),
    );
  }
}
