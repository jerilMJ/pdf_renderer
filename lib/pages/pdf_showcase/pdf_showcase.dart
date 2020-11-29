import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_renderer/data/models/pdf_details.dart';
import 'package:pdf_renderer/data/models/pdf_file.dart';
import 'package:pdf_renderer/pages/pdf_page/pdf_loader.dart';
import 'package:pdf_renderer/pages/pdf_showcase/bloc/pdf_showcase_bloc.dart';

List<PDFDetails> files = [
  PDFDetails(
    title: 'Maths',
    uploader: 'John Doe',
    uploadedDate: DateTime.now()..subtract(const Duration(days: 20)),
    pdfFile: PDFFile(fileURL: 'documents/text.pdf'),
  ),
  PDFDetails(
    title: 'CS',
    uploader: 'John Doe',
    uploadedDate: DateTime.now()..subtract(const Duration(days: 10)),
    pdfFile: PDFFile(fileURL: 'documents/text2.pdf'),
  ),
  PDFDetails(
    title: 'Life Skills',
    uploader: 'John Doe',
    uploadedDate: DateTime.now()..subtract(const Duration(days: 1)),
    pdfFile: PDFFile(fileURL: 'documents/text3.pdf'),
  ),
];

class PDFShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NOT.ED PDF'),
      ),
      body: BlocProvider(
        create: (_) => PDFShowcaseBloc(),
        child: BlocBuilder<PDFShowcaseBloc, PDFShowcaseState>(
          builder: (_, state) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: files.length,
              itemBuilder: (_, index) => PDFTile(files[index]),
            );
          },
        ),
      ),
    );
  }
}

class PDFTile extends StatefulWidget {
  const PDFTile(this.pdfDetails);

  final PDFDetails pdfDetails;

  @override
  _PDFTileState createState() => _PDFTileState();
}

class _PDFTileState extends State<PDFTile> {
  Future _imageLoadJob;

  @override
  void initState() {
    super.initState();
    _imageLoadJob =
        context.bloc<PDFShowcaseBloc>().getPDFCover(widget.pdfDetails.pdfFile);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => PDFLoader(widget.pdfDetails.pdfFile)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.4,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: FutureBuilder(
                future: _imageLoadJob,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    final Uint8List img = snapshot.data;
                    return Image.memory(img);
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                      ],
                    );
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(widget.pdfDetails.title),
                  Text(
                    '~${widget.pdfDetails.uploader}',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.60),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
