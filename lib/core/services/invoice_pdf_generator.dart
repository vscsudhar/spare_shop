import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'invoice_service.dart';

class InvoicePdfGenerator {
  static Future<Uint8List> generate(InvoiceModel invoice) async {
    final pdf = pw.Document();

    final b = invoice.business;
    final c = invoice.customer;
    final s = invoice.summary;
    final isIntraState = s.isIntraState;

    pw.Font fontBold;
    pw.Font fontNormal;
    pw.MemoryImage? logoImage;

    try {
      final regularData =
          await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
      final boldData = await rootBundle.load('assets/fonts/NotoSans-Bold.ttf');
      fontNormal = pw.Font.ttf(regularData);
      fontBold = pw.Font.ttf(boldData);
    } catch (_) {
      fontNormal = pw.Font.helvetica();
      fontBold = pw.Font.helveticaBold();
    }

    try {
      final logoBytes = await rootBundle.load('assets/images/logo_full.png');
      logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    } catch (_) {
      try {
        final logoBytes = await rootBundle.load('assets/images/logo_icon.png');
        logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
      } catch (_) {}
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return [
            // 1. Header Bar
            pw.Container(
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const pw.BoxDecoration(
                color: PdfColor.fromInt(0xFF0D1B2A),
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'TAX INVOICE',
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 16,
                          color: PdfColors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                      pw.Text(
                        'Original for Recipient | GST Compliance Under Section 31 CGST Act',
                        style: pw.TextStyle(
                            font: fontNormal,
                            fontSize: 8,
                            color: PdfColors.grey300),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: const pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFF00C853),
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
                    ),
                    child: pw.Text(
                      invoice.paymentStatus.toUpperCase(),
                      style: pw.TextStyle(
                          font: fontBold, fontSize: 9, color: PdfColors.white),
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 12),

            // 2. Business & Invoice Meta Info
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Seller Info & Logo
                pw.Expanded(
                  flex: 5,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (logoImage != null) ...[
                        pw.Container(
                          height: 32,
                          child: pw.Image(logoImage, fit: pw.BoxFit.contain),
                        ),
                        pw.SizedBox(height: 6),
                      ],
                      pw.Text(b.name,
                          style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 13,
                              color: const PdfColor.fromInt(0xFF0D1B2A))),
                      pw.Text(b.legalName,
                          style: pw.TextStyle(
                              font: fontNormal,
                              fontSize: 8,
                              color: PdfColors.grey700)),
                      pw.SizedBox(height: 4),
                      pw.Text(
                          '${b.addressLine1}${b.addressLine2.isNotEmpty ? ", ${b.addressLine2}" : ""}',
                          style: pw.TextStyle(font: fontNormal, fontSize: 8)),
                      pw.Text('${b.city}, ${b.state} - ${b.pincode}',
                          style: pw.TextStyle(font: fontNormal, fontSize: 8)),
                      pw.Text('Phone: ${b.phone} | Email: ${b.email}',
                          style: pw.TextStyle(font: fontNormal, fontSize: 8)),
                      pw.SizedBox(height: 4),
                      pw.Text('GSTIN: ${b.gstin} | PAN: ${b.pan}',
                          style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 8,
                              color: const PdfColor.fromInt(0xFF0D1B2A))),
                    ],
                  ),
                ),
                pw.SizedBox(width: 12),
                // Invoice Details Box
                pw.Expanded(
                  flex: 4,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: const PdfColor.fromInt(0xFFF8FAFC),
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(6)),
                      border: pw.Border.all(
                          color: const PdfColor.fromInt(0xFFE2E8F0)),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _metaRow('Invoice No:', invoice.invoiceNumber, fontBold,
                            fontNormal,
                            isHighlight: true),
                        _metaRow(
                            'Invoice Date:',
                            invoice.invoiceDate.toString().substring(0, 10),
                            fontBold,
                            fontNormal),
                        _metaRow('Order No:', invoice.orderNumber, fontBold,
                            fontNormal),
                        _metaRow(
                            'Order Date:',
                            invoice.orderDate.toString().substring(0, 10),
                            fontBold,
                            fontNormal),
                        _metaRow('Payment:', invoice.paymentMethod, fontBold,
                            fontNormal),
                        _metaRow('Channel:', invoice.channel.toUpperCase(),
                            fontBold, fontNormal),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 12),

            // 3. Customer Info Box
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: const PdfColor.fromInt(0xFFF8FAFC),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                border:
                    pw.Border.all(color: const PdfColor.fromInt(0xFFE2E8F0)),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('BILLED TO (CUSTOMER)',
                            style: pw.TextStyle(
                                font: fontBold,
                                fontSize: 8,
                                color: const PdfColor.fromInt(0xFF475569))),
                        pw.SizedBox(height: 3),
                        pw.Text(c.name,
                            style: pw.TextStyle(
                                font: fontBold,
                                fontSize: 10,
                                color: const PdfColor.fromInt(0xFF0D1B2A))),
                        pw.Text('Phone: ${c.phone}',
                            style: pw.TextStyle(font: fontNormal, fontSize: 8)),
                        pw.Text('Address: ${c.address}',
                            style: pw.TextStyle(font: fontNormal, fontSize: 8)),
                        pw.Text('State: ${c.state} (Code: ${c.stateCode})',
                            style: pw.TextStyle(font: fontNormal, fontSize: 8)),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('SHIPPING / DISPATCH DETAILS',
                            style: pw.TextStyle(
                                font: fontBold,
                                fontSize: 8,
                                color: const PdfColor.fromInt(0xFF475569))),
                        pw.SizedBox(height: 3),
                        pw.Text('Place of Supply: ${c.state}',
                            style: pw.TextStyle(font: fontNormal, fontSize: 8)),
                        pw.Text(
                            'Tax Applicable: ${isIntraState ? "Intra-State (CGST + SGST)" : "Inter-State (IGST)"}',
                            style: pw.TextStyle(font: fontNormal, fontSize: 8)),
                        pw.Text('Reverse Charge: No (Forward Charge)',
                            style: pw.TextStyle(font: fontNormal, fontSize: 8)),
                        pw.Text('GSTIN: Unregistered Person (B2C)',
                            style: pw.TextStyle(font: fontNormal, fontSize: 8)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 12),

            // 4. Itemized Table
            pw.Table(
              border: pw.TableBorder.all(
                  color: const PdfColor.fromInt(0xFFCBD5E1), width: 0.5),
              columnWidths: const {
                0: pw.FixedColumnWidth(22),
                1: pw.FlexColumnWidth(3.5),
                2: pw.FixedColumnWidth(38),
                3: pw.FixedColumnWidth(26),
                4: pw.FixedColumnWidth(55),
                5: pw.FixedColumnWidth(55),
                6: pw.FixedColumnWidth(48),
                7: pw.FixedColumnWidth(48),
                8: pw.FixedColumnWidth(60),
              },
              children: [
                // Header Row
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFFF1F5F9)),
                  children: [
                    _th('#', fontBold, align: pw.TextAlign.center),
                    _th('Item Description & SKU', fontBold),
                    _th('HSN', fontBold, align: pw.TextAlign.center),
                    _th('Qty', fontBold, align: pw.TextAlign.center),
                    _th('Excl. Tax (Rs)', fontBold, align: pw.TextAlign.right),
                    _th('Taxable (Rs)', fontBold, align: pw.TextAlign.right),
                    _th('CGST', fontBold, align: pw.TextAlign.right),
                    _th(isIntraState ? 'SGST' : 'IGST', fontBold,
                        align: pw.TextAlign.right),
                    _th('Total (Rs)', fontBold, align: pw.TextAlign.right),
                  ],
                ),
                // Item Rows
                ...invoice.items.map((item) {
                  return pw.TableRow(
                    children: [
                      _td('${item.sNo}', fontNormal,
                          align: pw.TextAlign.center),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(item.name,
                                style: pw.TextStyle(
                                    font: fontBold,
                                    fontSize: 8,
                                    color: const PdfColor.fromInt(0xFF0D1B2A))),
                            pw.Text('SKU: ${item.sku}',
                                style: pw.TextStyle(
                                    font: fontNormal,
                                    fontSize: 7,
                                    color: PdfColors.grey700)),
                          ],
                        ),
                      ),
                      _td(item.hsnCode, fontNormal, align: pw.TextAlign.center),
                      _td('${item.quantity}', fontNormal,
                          align: pw.TextAlign.center),
                      _td(item.unitPrice.toStringAsFixed(2), fontNormal,
                          align: pw.TextAlign.right),
                      _td(item.taxableValue.toStringAsFixed(2), fontNormal,
                          align: pw.TextAlign.right),
                      _td(
                          item.cgstAmount > 0
                              ? item.cgstAmount.toStringAsFixed(2)
                              : '-',
                          fontNormal,
                          align: pw.TextAlign.right),
                      _td(
                        isIntraState
                            ? (item.sgstAmount > 0
                                ? item.sgstAmount.toStringAsFixed(2)
                                : '-')
                            : (item.igstAmount > 0
                                ? item.igstAmount.toStringAsFixed(2)
                                : '-'),
                        fontNormal,
                        align: pw.TextAlign.right,
                      ),
                      _td(item.total.toStringAsFixed(2), fontBold,
                          align: pw.TextAlign.right),
                    ],
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 12),

            // 5. Summary & Totals
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Left Words & Compliance
                pw.Expanded(
                  flex: 5,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.all(8),
                        decoration: const pw.BoxDecoration(
                          color: PdfColor.fromInt(0xFFF1F5F9),
                          borderRadius:
                              pw.BorderRadius.all(pw.Radius.circular(4)),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('AMOUNT IN WORDS:',
                                style: pw.TextStyle(
                                    font: fontBold,
                                    fontSize: 7,
                                    color: const PdfColor.fromInt(0xFF475569))),
                            pw.SizedBox(height: 2),
                            pw.Text(s.amountInWords,
                                style: pw.TextStyle(
                                    font: fontBold,
                                    fontSize: 8,
                                    color: const PdfColor.fromInt(0xFF0D1B2A))),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        'Goods once sold are covered under VoltSpare 7-day verified RMA warranty.',
                        style: pw.TextStyle(
                            font: fontNormal,
                            fontSize: 7,
                            color: PdfColors.grey700),
                      ),
                      pw.Text(
                        'This is a computer-generated tax invoice and requires no physical signature under IT Act 2000.',
                        style: pw.TextStyle(
                            font: fontNormal,
                            fontSize: 7,
                            color: PdfColors.grey700),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(width: 14),
                // Right Totals Table
                pw.Expanded(
                  flex: 4,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: const PdfColor.fromInt(0xFFF8FAFC),
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(6)),
                      border: pw.Border.all(
                          color: const PdfColor.fromInt(0xFFE2E8F0)),
                    ),
                    child: pw.Column(
                      children: [
                        _summaryRow(
                            'Taxable Base Value:',
                            'Rs. ${s.taxableAmount.toStringAsFixed(2)}',
                            fontNormal),
                        if (isIntraState) ...[
                          _summaryRow(
                              'Central GST (CGST):',
                              'Rs. ${s.totalCgst.toStringAsFixed(2)}',
                              fontNormal),
                          _summaryRow(
                              'State GST (SGST):',
                              'Rs. ${s.totalSgst.toStringAsFixed(2)}',
                              fontNormal),
                        ] else ...[
                          _summaryRow(
                              'Integrated GST (IGST):',
                              'Rs. ${s.totalIgst.toStringAsFixed(2)}',
                              fontNormal),
                        ],
                        _summaryRow(
                          'Delivery / Shipping:',
                          s.deliveryCharges > 0
                              ? 'Rs. ${s.deliveryCharges.toStringAsFixed(2)}'
                              : 'FREE',
                          fontNormal,
                        ),
                        if (s.totalDiscount > 0)
                          _summaryRow(
                              'Discount:',
                              '-Rs. ${s.totalDiscount.toStringAsFixed(2)}',
                              fontNormal),
                        pw.Divider(
                            color: const PdfColor.fromInt(0xFF0D1B2A),
                            thickness: 1),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Grand Total:',
                                style: pw.TextStyle(
                                    font: fontBold,
                                    fontSize: 11,
                                    color: const PdfColor.fromInt(0xFF0D1B2A))),
                            pw.Text('Rs. ${s.grandTotal.toStringAsFixed(2)}',
                                style: pw.TextStyle(
                                    font: fontBold,
                                    fontSize: 12,
                                    color: const PdfColor.fromInt(0xFF00C853))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    );

    return await pdf.save();
  }

  static pw.Widget _metaRow(
      String label, String value, pw.Font fontBold, pw.Font fontNormal,
      {bool isHighlight = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style: pw.TextStyle(
                  font: fontNormal,
                  fontSize: 8,
                  color: const PdfColor.fromInt(0xFF475569))),
          pw.Text(
            value,
            style: pw.TextStyle(
              font: fontBold,
              fontSize: isHighlight ? 9 : 8,
              color: isHighlight
                  ? const PdfColor.fromInt(0xFF00C853)
                  : const PdfColor.fromInt(0xFF0D1B2A),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _th(String text, pw.Font font,
      {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
            font: font,
            fontSize: 7.5,
            color: const PdfColor.fromInt(0xFF334155)),
      ),
    );
  }

  static pw.Widget _td(String text, pw.Font font,
      {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
            font: font,
            fontSize: 7.5,
            color: const PdfColor.fromInt(0xFF0D1B2A)),
      ),
    );
  }

  static pw.Widget _summaryRow(String label, String value, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style: pw.TextStyle(
                  font: font,
                  fontSize: 8,
                  color: const PdfColor.fromInt(0xFF475569))),
          pw.Text(value,
              style: pw.TextStyle(
                  font: font,
                  fontSize: 8,
                  color: const PdfColor.fromInt(0xFF0D1B2A))),
        ],
      ),
    );
  }
}
