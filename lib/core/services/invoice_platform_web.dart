// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

Future<void> printInvoiceDocument(String htmlContent, String invoiceNumber, [Uint8List? pdfBytes]) async {
  try {
    final blob = html.Blob([htmlContent], 'text/html;charset=utf-8');
    final blobUrl = html.Url.createObjectUrlFromBlob(blob);

    final iframe = html.IFrameElement()
      ..src = blobUrl
      ..style.position = 'fixed'
      ..style.right = '0'
      ..style.bottom = '0'
      ..style.width = '0'
      ..style.height = '0'
      ..style.border = '0';

    html.document.body?.append(iframe);

    iframe.onLoad.listen((_) {
      Future.delayed(const Duration(milliseconds: 350), () {
        try {
          (iframe.contentWindow as dynamic)?.focus();
          (iframe.contentWindow as dynamic)?.print();
        } catch (e) {
          debugPrint('IFrame print fallback to window: $e');
          html.window.open(blobUrl, '_blank');
        }
        Future.delayed(const Duration(seconds: 30), () {
          iframe.remove();
          html.Url.revokeObjectUrl(blobUrl);
        });
      });
    });
  } catch (e) {
    debugPrint('Web print error: $e');
  }
}

Future<String?> downloadInvoiceDocument(String fileName, {Uint8List? pdfBytes, String? htmlContent}) async {
  try {
    final dynamic blob = pdfBytes != null
        ? html.Blob([pdfBytes], 'application/pdf')
        : html.Blob([htmlContent ?? ''], 'text/html;charset=utf-8');

    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
    return fileName;
  } catch (e) {
    debugPrint('Web download error: $e');
    return null;
  }
}

Future<bool> shareInvoiceDocument(String invoiceNumber, String summaryText, {String? filePath, Uint8List? pdfBytes, String? htmlContent}) async {
  final name = pdfBytes != null ? '$invoiceNumber.pdf' : '$invoiceNumber.html';
  await downloadInvoiceDocument(name, pdfBytes: pdfBytes, htmlContent: htmlContent);
  return true;
}

Future<bool> openInvoiceDocument(String filePath) async {
  return true;
}
