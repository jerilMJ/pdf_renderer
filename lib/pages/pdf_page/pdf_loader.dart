import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_renderer/data/models/pdf_file.dart';
import 'package:pdf_renderer/pages/pdf_page/bloc/pdf_page_bloc.dart';
import 'package:pdf_renderer/pages/pdf_page/pdf_page.dart';
import 'package:pdf_renderer/pages/pdf_page/providers/pdf_page_state_provider/pdf_page_state_provider.dart';
import 'package:provider/provider.dart';

class PDFLoader extends StatelessWidget {
  PDFLoader(this.pdfFile);

  final PDFFile pdfFile;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (_) => PDFPageBloc()..add(PDFPageLoadEvent(pdfFile)),
        child: BlocBuilder<PDFPageBloc, PDFPageState>(
          builder: (context, state) {
            if (state is PDFPageInitial) {
              return LoadSpinner();
            } else if (state is PDFPageLoading) {
              return LoadSpinner();
            } else if (state is PDFPageLoaded) {
              return ChangeNotifierProvider(
                create: (_) => PDFPageStateProvider(state.pdfFile),
                child: PDFPage(),
              );
            } else if (state is PDFPageError) {
              return Text('error occurred ${state.error}');
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class LoadSpinner extends StatelessWidget {
  const LoadSpinner({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
