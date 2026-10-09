import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

const MethodChannel _nativeChannel =
    MethodChannel('com.voltspare.shop/native_pdf_channel');

/// Print / Open invoice on Mobile / Desktop
Future<void> printInvoiceDocument(String htmlContent, String invoiceNumber,
    [Uint8List? pdfBytes]) async {
  try {
    final tempDir = await getTemporaryDirectory();
    if (pdfBytes != null) {
      final file = File('${tempDir.path}/$invoiceNumber.pdf');
      await file.writeAsBytes(pdfBytes);
      await openInvoiceDocument(file.path);
    } else {
      final file = File('${tempDir.path}/$invoiceNumber.html');
      await file.writeAsString(htmlContent);
      await openInvoiceDocument(file.path);
    }
  } catch (e) {
    debugPrint('Mobile invoice print/open error: $e');
  }
}

/// Download / Save vector PDF invoice document directly to public device storage
Future<String?> downloadInvoiceDocument(String fileName,
    {Uint8List? pdfBytes, String? htmlContent}) async {
  try {
    Directory? targetDir;

    if (Platform.isAndroid) {
      // Priority 1: Public Downloads Directory
      try {
        final publicDownload = Directory('/storage/emulated/0/Download');
        if (await publicDownload.exists()) {
          targetDir = publicDownload;
        }
      } catch (_) {}

      // Priority 2: External Storage Directory
      if (targetDir == null) {
        try {
          targetDir = await getExternalStorageDirectory();
        } catch (_) {}
      }

      // Priority 3: App Documents Directory
      targetDir ??= await getApplicationDocumentsDirectory();
    } else {
      targetDir = await getApplicationDocumentsDirectory();
    }

    final filePath = '${targetDir.path}/$fileName';
    final file = File(filePath);

    if (pdfBytes != null) {
      await file.writeAsBytes(pdfBytes, flush: true);
    } else if (htmlContent != null) {
      await file.writeAsString(htmlContent, flush: true);
    }

    debugPrint('Invoice PDF saved at: ${file.path}');

    // Immediately trigger Android MediaScanner so it appears in Recent Files / Downloads
    if (Platform.isAndroid) {
      try {
        await _nativeChannel.invokeMethod('scanFile', {'filePath': file.path});
      } catch (_) {}
    }

    return file.path;
  } catch (e) {
    debugPrint('Mobile invoice download error: $e');
    return null;
  }
}

/// Open invoice PDF with device default PDF / document viewer
Future<bool> openInvoiceDocument(String filePath) async {
  if (filePath.isEmpty) return false;

  final file = File(filePath);
  if (!await file.exists()) {
    debugPrint('openInvoiceDocument: file does not exist at $filePath');
    return false;
  }

  // 1. Try native Android FileProvider intent
  if (Platform.isAndroid) {
    try {
      final success = await _nativeChannel
          .invokeMethod<bool>('openFile', {'filePath': filePath});
      if (success == true) return true;
    } catch (e) {
      debugPrint(
          'Native openFile channel failed ($e), trying OpenFilex fallback...');
    }
  }

  // 2. OpenFilex fallback
  try {
    final result = await OpenFilex.open(filePath, type: 'application/pdf');
    return result.type == ResultType.done;
  } catch (e) {
    debugPrint('OpenFilex error: $e');
    return false;
  }
}

/// Share PDF invoice with native Android share sheet (WhatsApp, Gmail, Drive, etc.)
Future<bool> shareInvoiceDocument(String invoiceNumber, String summaryText,
    {String? filePath, Uint8List? pdfBytes, String? htmlContent}) async {
  try {
    String? targetFilePath = filePath;

    // If filePath wasn't provided or file doesn't exist, resolve/save it
    if (targetFilePath == null || !await File(targetFilePath).exists()) {
      final pdfFileName = '$invoiceNumber.pdf';

      // Check if it's already in public Downloads
      final publicFile = File('/storage/emulated/0/Download/$pdfFileName');
      if (await publicFile.exists() && await publicFile.length() > 0) {
        targetFilePath = publicFile.path;
      } else {
        // Save PDF to public Downloads or App directory
        targetFilePath = await downloadInvoiceDocument(
          pdfFileName,
          pdfBytes: pdfBytes,
          htmlContent: htmlContent,
        );
      }
    }

    if (targetFilePath == null) {
      debugPrint('Mobile share error: Target file path could not be resolved.');
      return false;
    }

    final file = File(targetFilePath);
    final exists = await file.exists();
    final size = exists ? await file.length() : 0;

    // Temporary debug logs as requested
    debugPrint('=== SHARE INVOICE DEBUG INFO ===');
    debugPrint('PDF path: ${file.path}');
    debugPrint('PDF exists: $exists');
    debugPrint('PDF file size: $size bytes');
    debugPrint('MIME type: application/pdf');

    if (!exists || size == 0) {
      debugPrint('Mobile share error: PDF file does not exist or is empty.');
      return false;
    }

    // 1. Native Android Intent share via MethodChannel and FileProvider
    if (Platform.isAndroid) {
      try {
        final success = await _nativeChannel.invokeMethod<bool>('shareFile', {
          'filePath': file.path,
          'title': 'Share Tax Invoice $invoiceNumber',
          'subject': 'VoltSpare Tax Invoice $invoiceNumber',
          'text': summaryText,
        });
        debugPrint('Share intent launched: $success');
        return success == true;
      } catch (e) {
        debugPrint('Native shareFile channel failed: $e');
        return false;
      }
    }

    // Non-Android platforms
    return true;
  } catch (e) {
    debugPrint('Mobile share error: $e');
    return false;
  }
}
