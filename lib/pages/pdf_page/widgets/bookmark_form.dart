import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_renderer/data/models/bookmark.dart';
import 'package:pdf_renderer/data/models/pdf_view_settings_store.dart';
import 'package:pdf_renderer/pages/pdf_page/bloc/pdf_page_bloc.dart';

class PortraitModeBookmarkForm extends StatefulWidget {
  const PortraitModeBookmarkForm({
    @required this.page,
    @required this.context,
    @required this.onAdd,
  });

  final int page;
  final BuildContext context;
  final Function onAdd;

  @override
  _PortraitModeBookmarkFormState createState() =>
      _PortraitModeBookmarkFormState();
}

class _PortraitModeBookmarkFormState extends State<PortraitModeBookmarkForm> {
  PDFPageBloc pdfPageBloc;
  BookmarkType type;

  String title;
  String description;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    type = BookmarkType.normal;
    pdfPageBloc = BlocProvider.of<PDFPageBloc>(widget.context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: Text(
            'Create a Boomark',
            style: TextStyle(fontSize: 24.0),
          ),
        ),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Title',
              prefixIcon: Icon(Icons.title),
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50.0),
                gapPadding: 10.0,
              ),
            ),
            controller: titleController,
          ),
        ),
        SizedBox(height: 10.0),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Description',
              prefixIcon: Icon(Icons.description),
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50.0),
                gapPadding: 10.0,
              ),
            ),
            controller: descriptionController,
          ),
        ),
        SizedBox(height: 10.0),
        Expanded(
          child: DropdownButtonFormField<BookmarkType>(
            decoration: InputDecoration(
              hintText: 'Description',
              prefixIcon: Icon(Icons.apps),
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50.0),
                gapPadding: 10.0,
              ),
            ),
            value: type,
            items: BookmarkType.values
                .map(
                  (value) => DropdownMenuItem<BookmarkType>(
                    value: value,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(PDFViewSettingsStore.bookmarkTypeTitle[value]),
                        Icon(PDFViewSettingsStore.bookmarkTypeIcon[value]),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              type = value;
            },
          ),
        ),
        RaisedButton(
          onPressed: () {
            title = titleController.value.text;
            if (title == null || title == '') title = 'Page ${widget.page + 1}';
            description = descriptionController.value.text;
            pdfPageBloc.add(BookmarkAddEvent(
              bookmark: Bookmark(
                page: widget.page,
                title: title,
                description: description,
                type: type,
              ),
              onAdd: () => widget.onAdd(),
            ));

            Navigator.maybePop(context);
          },
          child: Text('OK'),
          color: Colors.blue.shade400,
        ),
      ],
    );
  }
}

class LandscapeModeBookmarkForm extends StatefulWidget {
  const LandscapeModeBookmarkForm({
    @required this.page,
    @required this.context,
    @required this.onRemove,
  });

  final int page;
  final BuildContext context;
  final Function onRemove;

  @override
  _LandscapeModeBookmarkFormState createState() =>
      _LandscapeModeBookmarkFormState();
}

class _LandscapeModeBookmarkFormState extends State<LandscapeModeBookmarkForm> {
  PDFPageBloc pdfPageBloc;
  BookmarkType type;

  String title;
  String description;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    type = BookmarkType.normal;
    pdfPageBloc = BlocProvider.of<PDFPageBloc>(widget.context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Title',
                    prefixIcon: Icon(Icons.title),
                    contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(50.0),
                      gapPadding: 10.0,
                    ),
                  ),
                  controller: titleController,
                ),
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Description',
                    prefixIcon: Icon(Icons.description),
                    contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(50.0),
                      gapPadding: 10.0,
                    ),
                  ),
                  controller: descriptionController,
                ),
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: DropdownButtonFormField<BookmarkType>(
                  decoration: InputDecoration(
                    hintText: 'Description',
                    prefixIcon: Icon(Icons.apps),
                    contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(50.0),
                      gapPadding: 10.0,
                    ),
                  ),
                  value: type,
                  items: BookmarkType.values
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(PDFViewSettingsStore
                                  .bookmarkTypeTitle[value]),
                              Icon(
                                  PDFViewSettingsStore.bookmarkTypeIcon[value]),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    type = value;
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 20.0),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Create a Boomark',
                style: TextStyle(fontSize: 24.0),
              ),
              RaisedButton(
                onPressed: () {
                  title = titleController.value.text;
                  if (title == null || title == '')
                    title = 'Page ${widget.page}';
                  description = descriptionController.value.text;

                  pdfPageBloc.add(BookmarkAddEvent(
                    bookmark: Bookmark(
                      page: widget.page,
                      title: title,
                      description: description,
                      type: type,
                    ),
                    onAdd: () => widget.onRemove(),
                  ));

                  Navigator.maybePop(context);
                },
                child: Text('OK'),
                color: Colors.blue.shade400,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
