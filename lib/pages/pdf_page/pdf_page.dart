import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_renderer/pages/pdf_page/bloc/pdf_page_bloc.dart';
import 'package:pdf_renderer/pages/pdf_page/widgets/bookmark_form.dart';
import 'package:pdf_renderer/pages/pdf_page/widgets/bookmark_manager.dart';
import 'package:provider/provider.dart';

import '../../data/models/bookmark.dart';
import '../../data/models/pdf_view_settings_store.dart';
import 'providers/pdf_page_state_provider/pdf_page_state_provider.dart';
import 'widgets/pdf_widget.dart';
import 'widgets/scroll_bar_widget.dart';
import 'widgets/side_bar_widget.dart';

import 'package:intl/intl.dart';

class PDFPage extends StatefulWidget {
  const PDFPage({Key key}) : super(key: key);

  static _PDFPageState of(BuildContext context) =>
      context.findAncestorStateOfType<_PDFPageState>();

  @override
  _PDFPageState createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    Provider.of<PDFPageStateProvider>(
      context,
      listen: false,
    )
      ..initAnimations(this)
      ..listenToDrag();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    Provider.of<PDFPageStateProvider>(
      context,
      listen: false,
    ).reRender();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      resizeToAvoidBottomInset: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              PDFWidget(),
              ScrollbarWidget(),
              SidebarWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Future buildBookmarkManager(BuildContext callingContext) {
    return showDialog(
      context: callingContext,
      builder: (context) {
        return BookmarkManager(context: callingContext);
      },
    );
  }

  Future buildRemoveBookmarkDialog(
    BuildContext callingContext,
    Bookmark bookmark, {
    Function onRemove,
  }) {
    final pdfPageBloc = BlocProvider.of<PDFPageBloc>(callingContext);

    return showDialog(
      context: callingContext,
      builder: (context) {
        return Dialog(
          child: Container(
            height: MediaQuery.of(context).size.width / 2.5,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('Remove Bookmark ${bookmark.title}?'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        pdfPageBloc.add(BookmarkRemoveEvent(
                          bookmark: bookmark,
                          onRemove: () {
                            if (mounted) setState(() {});
                            onRemove();
                          },
                        ));

                        setState(() {});
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void buildBookmarkBottomSheet(BuildContext callingContext, int page) {
    showModalBottomSheet(
      isDismissible: true,
      context: callingContext,
      isScrollControlled: true,
      builder: (_) {
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: OrientationBuilder(
            builder: (_, orientation) => Container(
              padding: EdgeInsets.all(20.0),
              height: MediaQuery.of(context).size.height / 2,
              child: Form(
                child: orientation == Orientation.portrait
                    ? PortraitModeBookmarkForm(
                        page: page,
                        context: callingContext,
                        onAdd: () {
                          if (mounted) setState(() {});
                        },
                      )
                    : LandscapeModeBookmarkForm(
                        page: page,
                        context: callingContext,
                        onRemove: () {
                          if (mounted) setState(() {});
                        },
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
