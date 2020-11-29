abstract class PDFRelatedException implements Exception {}

class PDFLocalFetchException extends PDFRelatedException {}

class PDFNetworkFetchException extends PDFRelatedException {}
