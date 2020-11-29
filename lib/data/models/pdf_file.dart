import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class PDFFile extends Equatable {
  PDFFile({
    @required this.fileURL,
    String localPath,
  })  : assert(fileURL.startsWith('documents/')),
        isCached = false,
        localFilePath = localPath ?? fileURL.replaceFirst('documents/', '') {
    print(fileURL);
  }

  final String fileURL;
  final String localFilePath;
  final bool isCached;

  @override
  List<Object> get props => [fileURL];

  PDFFile copyWith({
    String fileURL,
    String localPath,
  }) {
    return PDFFile(
      fileURL: fileURL ?? this.fileURL,
      localPath: localPath ?? this.localFilePath,
    );
  }
}
