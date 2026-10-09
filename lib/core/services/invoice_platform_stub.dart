import 'package:flutter/foundation.dart';

Future<void> printInvoiceDocument(String htmlContent, String invoiceNumber,
    [Uint8List? pdfBytes]) async {
  debugPrint('Printing is not supported on this platform.');
}

Future<String?> downloadInvoiceDocument(String fileName,
    {Uint8List? pdfBytes, String? htmlContent}) async {
  debugPrint('Downloading is not supported on this platform.');
  return null;
}

Future<bool> shareInvoiceDocument(String invoiceNumber, String summaryText,
    {String? filePath, Uint8List? pdfBytes, String? htmlContent}) async {
  debugPrint('Sharing is not supported on this platform.');
  return false;
}

Future<bool> openInvoiceDocument(String filePath) async {
  debugPrint('Opening document is not supported on this platform.');
  return false;
}
