import 'package:flutter/services.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/services/api_client.dart';
import 'package:spare_shop/core/services/api_endpoints.dart';
import 'invoice_pdf_generator.dart';
import 'invoice_platform.dart' as platform;

/// Line item in a GST Tax Invoice
class InvoiceItemModel {
  final int sNo;
  final String name;
  final String sku;
  final String hsnCode;
  final int quantity;
  final double unitPrice;
  final double discount;
  final double taxableValue;
  final double gstRate;
  final double cgstRate;
  final double cgstAmount;
  final double sgstRate;
  final double sgstAmount;
  final double igstRate;
  final double igstAmount;
  final double total;

  const InvoiceItemModel({
    required this.sNo,
    required this.name,
    required this.sku,
    this.hsnCode = '8708',
    required this.quantity,
    required this.unitPrice,
    this.discount = 0.0,
    required this.taxableValue,
    required this.gstRate,
    required this.cgstRate,
    required this.cgstAmount,
    required this.sgstRate,
    required this.sgstAmount,
    required this.igstRate,
    required this.igstAmount,
    required this.total,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json, int index) {
    double parseNum(dynamic v) {
      if (v is num) return v.toDouble();
      if (v != null) return double.tryParse(v.toString()) ?? 0.0;
      return 0.0;
    }

    final qty = (json['quantity'] is num) ? (json['quantity'] as num).toInt() : (int.tryParse(json['quantity']?.toString() ?? '1') ?? 1);
    final unitPrice = parseNum(json['unitPrice']);
    final total = parseNum(json['total']);
    final taxRate = parseNum(json['taxPercentage'] ?? json['gstRate'] ?? 18);
    final taxableValue = parseNum(json['taxableValue'] ?? json['amount'] ?? (total > 0 ? total / (1 + taxRate / 100) : unitPrice * qty));

    return InvoiceItemModel(
      sNo: index + 1,
      name: (json['productName'] ?? json['name'] ?? 'Auto Spare Part').toString(),
      sku: (json['sku'] ?? 'SKU-UNKNOWN').toString(),
      hsnCode: (json['hsnCode'] ?? '8708').toString(),
      quantity: qty,
      unitPrice: unitPrice,
      discount: parseNum(json['discount']),
      taxableValue: taxableValue,
      gstRate: taxRate,
      cgstRate: parseNum(json['cgstRate']),
      cgstAmount: parseNum(json['cgstAmount']),
      sgstRate: parseNum(json['sgstRate']),
      sgstAmount: parseNum(json['sgstAmount']),
      igstRate: parseNum(json['igstRate']),
      igstAmount: parseNum(json['igstAmount']),
      total: total > 0 ? total : (taxableValue + parseNum(json['tax'])),
    );
  }
}

/// Business entity information
class InvoiceBusinessInfo {
  final String name;
  final String legalName;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String stateCode;
  final String pincode;
  final String phone;
  final String email;
  final String gstin;
  final String pan;
  final String website;

  const InvoiceBusinessInfo({
    this.name = 'VoltSpare Automotive',
    this.legalName = 'VoltSpare Automotive Technologies Pvt. Ltd.',
    this.addressLine1 = '12, MG Road, Landmark Block',
    this.addressLine2 = 'Indiranagar Commercial Zone',
    this.city = 'Bangalore',
    this.state = 'Karnataka',
    this.stateCode = '29',
    this.pincode = '560001',
    this.phone = '+91 99000 88000',
    this.email = 'billing@voltspare.com',
    this.gstin = '29AAAAA0000A1Z1',
    this.pan = 'AAAAA0000A',
    this.website = 'www.voltspare.com',
  });

  factory InvoiceBusinessInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const InvoiceBusinessInfo();
    return InvoiceBusinessInfo(
      name: (json['name'] ?? 'VoltSpare Automotive').toString(),
      legalName: (json['legalName'] ?? 'VoltSpare Automotive Technologies Pvt. Ltd.').toString(),
      addressLine1: (json['addressLine1'] ?? '12, MG Road, Landmark Block').toString(),
      addressLine2: (json['addressLine2'] ?? 'Indiranagar Commercial Zone').toString(),
      city: (json['city'] ?? 'Bangalore').toString(),
      state: (json['state'] ?? 'Karnataka').toString(),
      stateCode: (json['stateCode'] ?? '29').toString(),
      pincode: (json['postalCode'] ?? json['pincode'] ?? '560001').toString(),
      phone: (json['phone'] ?? '+91 99000 88000').toString(),
      email: (json['email'] ?? 'billing@voltspare.com').toString(),
      gstin: (json['gstin'] ?? '29AAAAA0000A1Z1').toString(),
      pan: (json['pan'] ?? 'AAAAA0000A').toString(),
      website: (json['website'] ?? 'www.voltspare.com').toString(),
    );
  }
}

/// Customer & Shipping Information
class InvoiceCustomerInfo {
  final String name;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String stateCode;
  final String gstin;

  const InvoiceCustomerInfo({
    required this.name,
    required this.phone,
    required this.address,
    this.city = '',
    this.state = 'Tamil Nadu',
    this.stateCode = '33',
    this.gstin = 'URP (Unregistered Person)',
  });

  factory InvoiceCustomerInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const InvoiceCustomerInfo(
        name: 'Valued Customer',
        phone: '',
        address: 'Standard Delivery Address',
      );
    }
    return InvoiceCustomerInfo(
      name: (json['name'] ?? 'Valued Customer').toString(),
      phone: (json['phone'] ?? '').toString(),
      address: (json['address'] ?? json['addressLine1'] ?? 'Standard Delivery Address').toString(),
      city: (json['city'] ?? '').toString(),
      state: (json['state'] ?? 'Tamil Nadu').toString(),
      stateCode: (json['stateCode'] ?? '33').toString(),
      gstin: (json['gstin'] ?? 'URP (Unregistered Person)').toString(),
    );
  }
}

/// Tax and Totals Summary
class InvoiceSummary {
  final double subtotal;
  final double totalDiscount;
  final double taxableAmount;
  final double totalCgst;
  final double totalSgst;
  final double totalIgst;
  final double totalTax;
  final double deliveryCharges;
  final double grandTotal;
  final String amountInWords;
  final bool isIntraState;

  const InvoiceSummary({
    required this.subtotal,
    required this.totalDiscount,
    required this.taxableAmount,
    required this.totalCgst,
    required this.totalSgst,
    required this.totalIgst,
    required this.totalTax,
    required this.deliveryCharges,
    required this.grandTotal,
    required this.amountInWords,
    required this.isIntraState,
  });

  factory InvoiceSummary.fromJson(Map<String, dynamic> json) {
    double parseNum(dynamic v) {
      if (v is num) return v.toDouble();
      if (v != null) return double.tryParse(v.toString()) ?? 0.0;
      return 0.0;
    }

    final subtotal = parseNum(json['subtotal'] ?? json['subTotal']);
    final grandTotal = parseNum(json['grandTotal'] ?? json['total']);
    final totalTax = parseNum(json['taxAmount'] ?? json['totalTax'] ?? json['tax']);
    final deliveryCharges = parseNum(json['deliveryCharge'] ?? json['deliveryFee']);
    final totalDiscount = parseNum(json['discount'] ?? json['discountAmount']);

    final taxableAmount =
        parseNum(json['taxableAmount'] ?? json['taxableValue'] ?? subtotal);

    return InvoiceSummary(
      subtotal: subtotal,
      totalDiscount: totalDiscount,
      taxableAmount: taxableAmount,
      totalCgst: parseNum(json['totalCgst']),
      totalSgst: parseNum(json['totalSgst']),
      totalIgst: parseNum(json['totalIgst']),
      totalTax: totalTax,
      deliveryCharges: deliveryCharges,
      grandTotal: grandTotal,
      amountInWords: (json['amountInWords'] ?? '').toString(),
      isIntraState: json['isIntraState'] ?? true,
    );
  }
}

/// Complete Tax Invoice Model
class InvoiceModel {
  final String invoiceNumber;
  final DateTime invoiceDate;
  final String orderId;
  final String orderNumber;
  final DateTime orderDate;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String channel;
  final String? fulfillmentHub;
  final InvoiceBusinessInfo business;
  final InvoiceCustomerInfo customer;
  final List<InvoiceItemModel> items;
  final InvoiceSummary summary;
  final List<String> terms;

  const InvoiceModel({
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.orderId,
    required this.orderNumber,
    required this.orderDate,
    required this.paymentMethod,
    this.paymentStatus = 'PAID',
    required this.orderStatus,
    required this.channel,
    this.fulfillmentHub,
    required this.business,
    required this.customer,
    required this.items,
    required this.summary,
    this.terms = const [
      'Products are covered under applicable manufacturer/VoltSpare warranty and RMA policy.',
      'Subject to competent jurisdiction in India, under applicable consumer protection laws.',
      'This is a computer-generated tax invoice and requires no physical signature under IT Act 2000.',
    ],
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    final itemsList = rawItems
        .asMap()
        .entries
        .map((entry) => InvoiceItemModel.fromJson(entry.value as Map<String, dynamic>, entry.key))
        .toList();

    DateTime parseDate(dynamic d) {
      if (d is DateTime) return d;
      if (d != null) {
        final parsed = DateTime.tryParse(d.toString());
        if (parsed != null) return parsed;
      }
      return DateTime.now();
    }

    final rawTerms = json['terms'] as List<dynamic>?;
    final List<String> termsList = rawTerms != null
        ? rawTerms.map((t) => t.toString()).toList()
        : const [
            'Products are covered under applicable manufacturer/VoltSpare warranty and RMA policy.',
            'Subject to competent jurisdiction in India, under applicable consumer protection laws.',
            'This is a computer-generated tax invoice and requires no physical signature under IT Act 2000.',
          ];

    final orderRef = json['order'];
    String ordId = '';
    if (orderRef is Map) {
      ordId = (orderRef['_id'] ?? orderRef['id'] ?? '').toString();
    } else {
      ordId = (orderRef ?? json['orderId'] ?? '').toString();
    }

    return InvoiceModel(
      invoiceNumber: (json['invoiceNumber'] ?? 'INV-UNKNOWN').toString(),
      invoiceDate: parseDate(json['invoiceDate'] ?? json['createdAt']),
      orderId: ordId,
      orderNumber: (json['orderNumber'] ?? 'ORD-UNKNOWN').toString(),
      orderDate: parseDate(json['orderDate'] ?? json['createdAt']),
      paymentMethod: (json['paymentMethod'] ?? 'Online Payment').toString(),
      paymentStatus: (json['paymentStatus'] ?? 'PAID').toString(),
      orderStatus: (json['orderStatus'] ?? 'processing').toString(),
      channel: (json['channel'] ?? 'app').toString(),
      fulfillmentHub: json['fulfillmentHub']?.toString(),
      business: InvoiceBusinessInfo.fromJson(json['business'] as Map<String, dynamic>?),
      customer: InvoiceCustomerInfo.fromJson(json['customer'] as Map<String, dynamic>?),
      items: itemsList,
      summary: InvoiceSummary.fromJson(json),
      terms: termsList,
    );
  }
}

/// Service handling Invoice API communications, PDF generation, and Printing
class InvoiceService {
  final ApiClient _apiClient;

  InvoiceService({ApiClient? apiClient})
      : _apiClient = apiClient ?? locator<ApiClient>();

  /// Fetch or create invoice for an order directly from the backend API
  Future<InvoiceModel> getInvoiceForOrder(String orderId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.orderInvoice(orderId));
      final data = response.data['data'] ?? {};
      return InvoiceModel.fromJson(Map<String, dynamic>.from(data));
    } catch (_) {
      // If GET fails or invoice not initialized, trigger POST endpoint
      final postResponse = await _apiClient.post(ApiEndpoints.orderInvoice(orderId));
      final postData = postResponse.data['data'] ?? {};
      return InvoiceModel.fromJson(Map<String, dynamic>.from(postData));
    }
  }

  /// Copy invoice ID and short details to clipboard
  Future<void> copyInvoiceNumber(String invoiceNumber) async {
    await Clipboard.setData(ClipboardData(text: invoiceNumber));
  }

  /// Print or Save invoice on Web / Desktop browser
  Future<void> printInvoice(InvoiceModel invoice) async {
    final htmlContent = generateInvoiceHtml(invoice);
    final pdfBytes = await InvoicePdfGenerator.generate(invoice);
    await platform.printInvoiceDocument(
        htmlContent, invoice.invoiceNumber, pdfBytes);
  }

  /// Download standalone PDF Invoice document
  Future<String?> downloadInvoiceFile(InvoiceModel invoice) async {
    final htmlContent = generateInvoiceHtml(invoice);
    final pdfBytes = await InvoicePdfGenerator.generate(invoice);
    return await platform.downloadInvoiceDocument(
      '${invoice.invoiceNumber}.pdf',
      pdfBytes: pdfBytes,
      htmlContent: htmlContent,
    );
  }

  /// Share invoice with native OS share sheet (WhatsApp, Gmail, Telegram, etc.)
  Future<bool> shareInvoice(InvoiceModel invoice) async {
    final pdfBytes = await InvoicePdfGenerator.generate(invoice);
    final fileName = '${invoice.invoiceNumber}.pdf';
    final savedPath = await platform.downloadInvoiceDocument(
      fileName,
      pdfBytes: pdfBytes,
    );
    final summaryText =
        'VoltSpare Tax Invoice #${invoice.invoiceNumber}\nOrder #${invoice.orderNumber}\nAmount: ₹${invoice.summary.grandTotal.toStringAsFixed(2)}\nStatus: ${invoice.paymentStatus}';
    return await platform.shareInvoiceDocument(
      invoice.invoiceNumber,
      summaryText,
      filePath: savedPath,
      pdfBytes: pdfBytes,
    );
  }

  /// Open local PDF document in device PDF viewer
  Future<bool> openInvoiceFile(String filePath) async {
    return await platform.openInvoiceDocument(filePath);
  }

  /// Generate high-fidelity Tax Invoice HTML document
  String generateInvoiceHtml(InvoiceModel invoice) {
    final business = invoice.business;
    final customer = invoice.customer;
    final summary = invoice.summary;

    final dateFormatted = invoice.invoiceDate.toString().substring(0, 10);
    final orderDateFormatted = invoice.orderDate.toString().substring(0, 10);

    final itemsRows = invoice.items.map((item) {
      return '''
      <tr>
        <td style="text-align: center;">${item.sNo}</td>
        <td>
          <strong>${item.name}</strong><br>
          <span style="color: #64748b; font-size: 10px;">SKU: ${item.sku}</span>
        </td>
        <td style="text-align: center;">${item.hsnCode}</td>
        <td style="text-align: center;">${item.quantity}</td>
        <td style="text-align: right;">₹${item.unitPrice.toStringAsFixed(2)}</td>
        <td style="text-align: right;">₹${item.taxableValue.toStringAsFixed(2)}</td>
        <td style="text-align: right;">${item.cgstAmount > 0 ? '₹${item.cgstAmount.toStringAsFixed(2)}' : '-'}</td>
        <td style="text-align: right;">${summary.isIntraState ? (item.sgstAmount > 0 ? '₹${item.sgstAmount.toStringAsFixed(2)}' : '-') : (item.igstAmount > 0 ? '₹${item.igstAmount.toStringAsFixed(2)}' : '-')}</td>
        <td style="text-align: right; font-weight: bold;">₹${item.total.toStringAsFixed(2)}</td>
      </tr>
      ''';
    }).join('');

    return '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Tax Invoice - ${invoice.invoiceNumber}</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: #f8fafc;
      color: #1e293b;
      padding: 24px;
      font-size: 12px;
    }
    .invoice-container {
      max-width: 820px;
      margin: 0 auto;
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 8px;
      padding: 32px;
      box-shadow: 0 4px 16px rgba(0,0,0,0.06);
    }
    .header-bar {
      display: flex;
      justify-content: space-between;
      border-bottom: 2px solid #0f172a;
      padding-bottom: 16px;
      margin-bottom: 20px;
    }
    .brand-section h1 {
      font-size: 20px;
      font-weight: 800;
      color: #0f172a;
      letter-spacing: -0.5px;
    }
    .brand-section .subtitle {
      font-size: 11px;
      color: #64748b;
      margin-bottom: 8px;
    }
    .brand-details {
      font-size: 11px;
      color: #334155;
      line-height: 1.5;
    }
    .invoice-tag-section {
      text-align: right;
    }
    .invoice-badge {
      display: inline-block;
      background: #0f172a;
      color: #fff;
      font-size: 11px;
      font-weight: 700;
      letter-spacing: 1px;
      padding: 4px 12px;
      border-radius: 4px;
      margin-bottom: 8px;
    }
    .invoice-meta-table {
      font-size: 11px;
      border-collapse: collapse;
      margin-left: auto;
    }
    .invoice-meta-table td {
      padding: 2px 6px;
    }
    .invoice-meta-table td.label {
      color: #64748b;
      text-align: right;
    }
    .invoice-meta-table td.val {
      font-weight: 600;
      color: #0f172a;
      text-align: right;
    }
    .info-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
      margin-bottom: 20px;
    }
    .info-card {
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      border-radius: 6px;
      padding: 12px 14px;
    }
    .info-card h3 {
      font-size: 11px;
      font-weight: 700;
      color: #475569;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      margin-bottom: 6px;
      border-bottom: 1px solid #cbd5e1;
      padding-bottom: 4px;
    }
    .info-card p {
      font-size: 11px;
      line-height: 1.5;
      color: #1e293b;
    }
    .items-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 20px;
      font-size: 11px;
    }
    .items-table th {
      background: #f1f5f9;
      color: #334155;
      font-weight: 600;
      text-align: left;
      padding: 8px 10px;
      border: 1px solid #cbd5e1;
    }
    .items-table td {
      padding: 8px 10px;
      border: 1px solid #e2e8f0;
      vertical-align: top;
    }
    .items-table tbody tr:nth-child(even) {
      background: #fafafa;
    }
    .bottom-section {
      display: grid;
      grid-template-columns: 1.3fr 1fr;
      gap: 20px;
      margin-top: 10px;
    }
    .summary-card {
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      border-radius: 6px;
      padding: 12px;
    }
    .summary-table {
      width: 100%;
      border-collapse: collapse;
      font-size: 11px;
    }
    .summary-table td {
      padding: 4px 6px;
    }
    .summary-table tr.grand-total td {
      font-size: 13px;
      font-weight: 700;
      color: #0f172a;
      border-top: 2px solid #0f172a;
      border-bottom: 2px solid #0f172a;
      padding: 8px 6px;
    }
    .words-box {
      margin-top: 14px;
      padding: 10px;
      background: #f1f5f9;
      border-radius: 6px;
      font-size: 11px;
      border-left: 3px solid #10b981;
    }
    .terms-box {
      margin-top: 16px;
      padding-top: 10px;
      border-top: 1px dashed #cbd5e1;
      font-size: 10px;
      color: #64748b;
      line-height: 1.4;
    }
    .signature-box {
      text-align: right;
      margin-top: 24px;
    }
    .sign-line {
      display: inline-block;
      width: 180px;
      border-top: 1px solid #0f172a;
      margin-top: 28px;
      padding-top: 4px;
      font-size: 11px;
      font-weight: 600;
      color: #334155;
    }
    .no-print-bar {
      position: fixed;
      top: 12px;
      right: 20px;
      background: #0f172a;
      color: #fff;
      padding: 8px 16px;
      border-radius: 6px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.25);
      z-index: 9999;
      display: flex;
      gap: 12px;
      align-items: center;
    }
    .no-print-bar button {
      background: #10b981;
      color: #fff;
      border: none;
      padding: 6px 14px;
      border-radius: 4px;
      font-weight: 600;
      cursor: pointer;
      font-size: 12px;
    }
    @media print {
      body { background: #ffffff; padding: 0; margin: 0; }
      .invoice-container { box-shadow: none; border: none; padding: 10mm; max-width: 100%; }
      .no-print-bar { display: none !important; }
      @page { size: A4 portrait; margin: 8mm; }
    }
  </style>
</head>
<body>

  <div class="no-print-bar">
    <span>GST Tax Invoice Preview</span>
    <button onclick="window.print()">Print / Save PDF</button>
  </div>

  <div class="invoice-container">
    <div class="header-bar">
      <div class="brand-section">
        <div style="margin-bottom: 8px;">
          <img src="assets/images/logo_full.png" alt="VoltSpare" style="height: 36px; max-width: 180px; object-fit: contain;" onerror="this.style.display='none'">
        </div>
        <h1>${business.name}</h1>
        <div class="subtitle">${business.legalName}</div>
        <div class="brand-details">
          ${business.addressLine1}, ${business.addressLine2}<br>
          ${business.city}, ${business.state} - ${business.pincode}<br>
          <strong>GSTIN:</strong> ${business.gstin} | <strong>PAN:</strong> ${business.pan}<br>
          <strong>Email:</strong> ${business.email} | <strong>Phone:</strong> ${business.phone}
        </div>
      </div>
      <div class="invoice-tag-section">
        <div class="invoice-badge">TAX INVOICE</div>
        <table class="invoice-meta-table">
          <tr>
            <td class="label">Invoice No:</td>
            <td class="val">${invoice.invoiceNumber}</td>
          </tr>
          <tr>
            <td class="label">Invoice Date:</td>
            <td class="val">$dateFormatted</td>
          </tr>
          <tr>
            <td class="label">Order No:</td>
            <td class="val">${invoice.orderNumber}</td>
          </tr>
          <tr>
            <td class="label">Order Date:</td>
            <td class="val">$orderDateFormatted</td>
          </tr>
          <tr>
            <td class="label">Payment Mode:</td>
            <td class="val">${invoice.paymentMethod}</td>
          </tr>
          <tr>
            <td class="label">Place of Supply:</td>
            <td class="val">${customer.state} (${customer.stateCode})</td>
          </tr>
        </table>
      </div>
    </div>

    <div class="info-grid">
      <div class="info-card">
        <h3>Billed To & Shipped To (Customer)</h3>
        <p>
          <strong>${customer.name}</strong><br>
          ${customer.address}<br>
          ${customer.city.isNotEmpty ? '${customer.city}, ' : ''}${customer.state} (Code: ${customer.stateCode})<br>
          <strong>Phone:</strong> ${customer.phone}<br>
          <strong>GSTIN:</strong> ${customer.gstin}
        </p>
      </div>
      <div class="info-card">
        <h3>Dispatch & Fulfillment Details</h3>
        <p>
          <strong>Fulfillment Hub:</strong> ${invoice.fulfillmentHub ?? 'Central Dispatch Hub'}<br>
          <strong>Sales Channel:</strong> ${invoice.channel.toUpperCase()}<br>
          <strong>Order Status:</strong> ${invoice.orderStatus}<br>
          <strong>Payment Status:</strong> ${invoice.paymentStatus}<br>
          <strong>Reverse Charge:</strong> No (Applicable under Forward Charge)
        </p>
      </div>
    </div>

    <table class="items-table">
      <thead>
        <tr>
          <th style="width: 35px; text-align: center;">#</th>
          <th>Item Description & SKU</th>
          <th style="width: 60px; text-align: center;">HSN</th>
          <th style="width: 45px; text-align: center;">Qty</th>
          <th style="width: 75px; text-align: right;">Actual Price<br><small style="font-weight: normal; font-size: 9px; color: #64748b;">(Excl. Tax)</small></th>
          <th style="width: 80px; text-align: right;">Taxable Value<br><small style="font-weight: normal; font-size: 9px; color: #64748b;">(Excl. Tax)</small></th>
          <th style="width: 70px; text-align: right;">CGST</th>
          <th style="width: 70px; text-align: right;">${summary.isIntraState ? 'SGST' : 'IGST'}</th>
          <th style="width: 85px; text-align: right;">Selling Price<br><small style="font-weight: normal; font-size: 9px; color: #64748b;">(Incl. Tax)</small></th>
        </tr>
      </thead>
      <tbody>
        $itemsRows
      </tbody>
    </table>

    <div class="bottom-section">
      <div>
        <div class="words-box">
          <strong>Amount in Words:</strong><br>
          <span>${summary.amountInWords}</span>
        </div>

        <div class="terms-box">
          <strong>Terms & Conditions:</strong>
          <ol style="padding-left: 16px; margin-top: 4px;">
            ${invoice.terms.map((t) => '<li>$t</li>').join('')}
          </ol>
        </div>
      </div>

      <div class="summary-card">
        <table class="summary-table">
          <tr>
            <td>Actual Price (Excl. Tax):</td>
            <td style="text-align: right;">₹${summary.taxableAmount.toStringAsFixed(2)}</td>
          </tr>
          <tr>
            <td>Tax Included (GST):</td>
            <td style="text-align: right; color: #059669;">₹${summary.totalTax.toStringAsFixed(2)}</td>
          </tr>
          <tr>
            <td>Selling Price (Item Total):</td>
            <td style="text-align: right;">₹${(summary.taxableAmount + summary.totalTax).toStringAsFixed(2)}</td>
          </tr>
          ${summary.isIntraState ? '''
          <tr>
            <td>Central GST (CGST):</td>
            <td style="text-align: right;">₹${summary.totalCgst.toStringAsFixed(2)}</td>
          </tr>
          <tr>
            <td>State GST (SGST):</td>
            <td style="text-align: right;">₹${summary.totalSgst.toStringAsFixed(2)}</td>
          </tr>
          ''' : '''
          <tr>
            <td>Integrated GST (IGST):</td>
            <td style="text-align: right;">₹${summary.totalIgst.toStringAsFixed(2)}</td>
          </tr>
          '''}
          ${summary.deliveryCharges > 0 ? '''
          <tr>
            <td>Delivery / Freight Charges:</td>
            <td style="text-align: right;">₹${summary.deliveryCharges.toStringAsFixed(2)}</td>
          </tr>
          ''' : ''}
          ${summary.totalDiscount > 0 ? '''
          <tr>
            <td>Discount Applied:</td>
            <td style="text-align: right; color: #dc2626;">-₹${summary.totalDiscount.toStringAsFixed(2)}</td>
          </tr>
          ''' : ''}
          <tr class="grand-total">
            <td>Grand Total:</td>
            <td style="text-align: right;">₹${summary.grandTotal.toStringAsFixed(2)}</td>
          </tr>
        </table>

        <div class="signature-box">
          <div class="sign-line">
            For ${business.name}<br>
            <span style="font-size: 10px; color: #64748b; font-weight: normal;">Authorized Signatory</span>
          </div>
        </div>
      </div>
    </div>
  </div>

</body>
</html>
    ''';
  }
}
