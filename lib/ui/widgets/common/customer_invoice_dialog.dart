import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spare_shop/core/services/invoice_service.dart';
import 'package:spare_shop/ui/common/app_colors.dart';

class CustomerInvoiceDialog extends StatelessWidget {
  final InvoiceModel invoice;

  const CustomerInvoiceDialog({
    Key? key,
    required this.invoice,
  }) : super(key: key);

  static Future<void> show(BuildContext context, InvoiceModel invoice) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => CustomerInvoiceDialog(invoice: invoice),
    );
  }

  @override
  Widget build(BuildContext context) {
    final invoiceService = InvoiceService();
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 24,
        vertical: isMobile ? 12 : 24,
      ),
      child: Container(
        width: isMobile ? double.infinity : 860,
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(context).size.height * (isMobile ? 0.96 : 0.92),
        ),
        decoration: BoxDecoration(
          color: kcVoltSpareDark,
          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Modal Action Bar
            _buildTopActionBar(context, invoiceService, isMobile),

            // Scrollable Document View
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 10 : 20,
                  vertical: 10,
                ),
                child: Center(
                  child: Container(
                    width: 800,
                    padding: EdgeInsets.all(isMobile ? 14 : 28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: kcVoltSpareTextPrimary,
                        fontSize: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Business Header & Invoice Meta
                          _buildHeaderSection(context, isMobile),
                          const SizedBox(height: 16),

                          // 2. Customer & Dispatch Details Box
                          _buildCustomerAndDispatchSection(isMobile),
                          const SizedBox(height: 16),

                          // 3. Product Line Items Section
                          _buildItemsSection(context, isMobile),
                          const SizedBox(height: 16),

                          // 4. Amount in Words & Totals Breakdown
                          _buildTotalsAndSummarySection(isMobile),
                          const SizedBox(height: 20),

                          // 5. Terms & Conditions + Signatory
                          _buildFooterSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopActionBar(
      BuildContext context, InvoiceService service, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 18,
        vertical: isMobile ? 10 : 12,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          // Invoice Number Pill
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: kcVoltSpareEVGreen.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: kcVoltSpareEVGreen.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.receipt_long_rounded,
                      color: kcVoltSpareEVGreen, size: 15),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      invoice.invoiceNumber,
                      style: const TextStyle(
                        color: kcVoltSpareEVGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: 'Copy Invoice ID',
            icon:
                const Icon(Icons.copy_rounded, color: Colors.white70, size: 16),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: invoice.invoiceNumber));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Copied ${invoice.invoiceNumber} to clipboard!'),
                  backgroundColor: kcVoltSpareEVGreen,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          const Spacer(),

          // Share Button
          IconButton(
            tooltip: 'Share Invoice',
            icon:
                const Icon(Icons.share_rounded, color: Colors.white, size: 18),
            onPressed: () async {
              try {
                final shared = await service.shareInvoice(invoice);
                if (!shared && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Unable to share invoice. Please try again.'),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Unable to share invoice. Please try again.'),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              }
            },
          ),

          // Download Button
          IconButton(
            tooltip: 'Download Invoice',
            icon: const Icon(Icons.download_rounded,
                color: Colors.white, size: 20),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);

              try {
                final path = await service.downloadInvoiceFile(invoice);
                if (!context.mounted) return;

                if (path == null) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Unable to save invoice.'),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 3),
                    ),
                  );
                  return;
                }

                // Close the invoice modal dialog after successful download
                navigator.pop();

                messenger.showSnackBar(
                  SnackBar(
                    content: const Text('Invoice downloaded successfully'),
                    backgroundColor: kcVoltSpareEVGreen,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 6),
                    action: SnackBarAction(
                      label: 'View Invoice',
                      textColor: Colors.white,
                      onPressed: () async {
                        try {
                          final opened = await service.openInvoiceFile(path);
                          if (!opened) {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'No PDF viewer is available on this device.'),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        } catch (_) {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Invoice file could not be found.'),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              } catch (_) {
                if (context.mounted) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Unable to generate invoice PDF.'),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              }
            },
          ),

          // Print / Save PDF Button
          if (!isMobile)
            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kcVoltSpareEVGreen,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.print_rounded, size: 15),
                label: const Text(
                  'Print',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                onPressed: () => service.printInvoice(invoice),
              ),
            ),

          IconButton(
            tooltip: 'Close',
            icon:
                const Icon(Icons.close_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, bool isMobile) {
    final b = invoice.business;
    final dateStr = invoice.invoiceDate.toString().substring(0, 10);
    final orderDateStr = invoice.orderDate.toString().substring(0, 10);

    final businessInfoWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/logo_full.png',
              height: 28,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/logo_icon.png',
                height: 28,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${b.addressLine1}${b.addressLine2.isNotEmpty ? ", ${b.addressLine2}" : ""}',
          style: const TextStyle(fontSize: 11, color: Color(0xFF334155)),
        ),
        Text(
          '${b.city}, ${b.state} - ${b.pincode}',
          style: const TextStyle(fontSize: 11, color: Color(0xFF334155)),
        ),
        const SizedBox(height: 3),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 11, color: Color(0xFF334155)),
            children: [
              const TextSpan(
                  text: 'GSTIN: ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '${b.gstin} | '),
              const TextSpan(
                  text: 'PAN: ', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: b.pan),
            ],
          ),
        ),
        Text(
          'Email: ${b.email} | Contact: ${b.phone}',
          style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
        ),
      ],
    );

    final metaInfoWidget = Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'TAX INVOICE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 11,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _metaKeyValue('Invoice No:', invoice.invoiceNumber, isBold: true),
        _metaKeyValue('Invoice Date:', dateStr),
        _metaKeyValue('Order No:', invoice.orderNumber, isBold: true),
        _metaKeyValue('Order Date:', orderDateStr),
        _metaKeyValue('Payment Mode:', invoice.paymentMethod),
        _metaKeyValue(
          'Place of Supply:',
          '${invoice.customer.state} (${invoice.customer.stateCode})',
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.only(bottom: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF0F172A), width: 2)),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                businessInfoWidget,
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 10),
                metaInfoWidget,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: businessInfoWidget),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: metaInfoWidget),
              ],
            ),
    );
  }

  Widget _metaKeyValue(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerAndDispatchSection(bool isMobile) {
    final c = invoice.customer;

    final customerCard = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BILLED TO & SHIPPED TO (CUSTOMER)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
              color: Color(0xFF475569),
              letterSpacing: 0.5,
            ),
          ),
          const Divider(height: 10, color: Color(0xFFCBD5E1)),
          Text(
            c.name,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 2),
          Text(
            c.address,
            style: const TextStyle(
                fontSize: 11, color: Color(0xFF334155), height: 1.3),
          ),
          Text(
            '${c.city.isNotEmpty ? "${c.city}, " : ""}${c.state} (Code: ${c.stateCode})',
            style: const TextStyle(fontSize: 11, color: Color(0xFF334155)),
          ),
          const SizedBox(height: 2),
          if (c.phone.isNotEmpty)
            Text('Contact: ${c.phone}',
                style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
          Text('GSTIN: ${c.gstin}',
              style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
        ],
      ),
    );

    final dispatchCard = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DISPATCH & FULFILLMENT DETAILS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
              color: Color(0xFF475569),
              letterSpacing: 0.5,
            ),
          ),
          const Divider(height: 10, color: Color(0xFFCBD5E1)),
          _detailLine('Fulfillment Hub',
              invoice.fulfillmentHub ?? 'Central Dispatch Hub'),
          _detailLine('Sales Channel',
              invoice.channel == 'pos' ? 'Store POS' : 'VoltSpare App'),
          _detailLine('Order Status', invoice.orderStatus.toUpperCase()),
          _detailLine('Payment Status', invoice.paymentStatus.toUpperCase()),
          _detailLine('Reverse Charge', 'No (Forward Charge)'),
        ],
      ),
    );

    if (isMobile) {
      return Column(
        children: [
          customerCard,
          const SizedBox(height: 10),
          dispatchCard,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: customerCard),
        const SizedBox(width: 14),
        Expanded(child: dispatchCard),
      ],
    );
  }

  Widget _detailLine(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text('$label: ',
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          Expanded(
            child: Text(
              val,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(BuildContext context, bool isMobile) {
    final isIntraState = invoice.summary.isIntraState;

    if (isMobile) {
      // Mobile Responsive Cards List
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ORDER ITEMS & GST BREAKDOWN',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Color(0xFF475569),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: invoice.items.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 14, color: Color(0xFFCBD5E1)),
              itemBuilder: (ctx, i) {
                final it = invoice.items[i];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${it.sNo}',
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF334155)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                it.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xFF0F172A)),
                              ),
                              Text(
                                'SKU: ${it.sku} | HSN: ${it.hsnCode}',
                                style: const TextStyle(
                                    fontSize: 10, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '₹${it.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Qty: ${it.quantity} × ₹${it.unitPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 10, color: Color(0xFF475569))),
                          Text(
                              'Taxable: ₹${it.taxableValue.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 10, color: Color(0xFF475569))),
                          Text(
                            isIntraState
                                ? 'GST (${it.gstRate.toInt()}%): ₹${(it.cgstAmount + it.sgstAmount).toStringAsFixed(2)}'
                                : 'IGST (${it.gstRate.toInt()}%): ₹${it.igstAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: kcVoltSpareEVGreen),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
    }

    // Desktop Tabular Grid
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCBD5E1)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(36),
          1: FlexColumnWidth(4.0),
          2: FixedColumnWidth(55),
          3: FixedColumnWidth(42),
          4: FixedColumnWidth(70),
          5: FixedColumnWidth(75),
          6: FixedColumnWidth(65),
          7: FixedColumnWidth(65),
          8: FixedColumnWidth(80),
        },
        children: [
          TableRow(
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              border: Border(bottom: BorderSide(color: Color(0xFFCBD5E1))),
            ),
            children: [
              _th('#', align: TextAlign.center),
              _th('Item Description & SKU'),
              _th('HSN', align: TextAlign.center),
              _th('Qty', align: TextAlign.center),
              _th('Actual Price\n(Excl. Tax)', align: TextAlign.right),
              _th('Taxable\nValue', align: TextAlign.right),
              _th('CGST', align: TextAlign.right),
              _th(isIntraState ? 'SGST' : 'IGST', align: TextAlign.right),
              _th('Selling Price\n(Incl. Tax)', align: TextAlign.right),
            ],
          ),
          ...invoice.items.map((item) {
            return TableRow(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              children: [
                _td('${item.sNo}', align: TextAlign.center),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Color(0xFF0F172A)),
                      ),
                      Text('SKU: ${item.sku}',
                          style: const TextStyle(
                              fontSize: 10, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
                _td(item.hsnCode, align: TextAlign.center),
                _td('${item.quantity}', align: TextAlign.center),
                _td(item.unitPrice.toStringAsFixed(2), align: TextAlign.right),
                _td(item.taxableValue.toStringAsFixed(2),
                    align: TextAlign.right),
                _td(
                    item.cgstAmount > 0
                        ? item.cgstAmount.toStringAsFixed(2)
                        : '-',
                    align: TextAlign.right),
                _td(
                  isIntraState
                      ? (item.sgstAmount > 0
                          ? item.sgstAmount.toStringAsFixed(2)
                          : '-')
                      : (item.igstAmount > 0
                          ? item.igstAmount.toStringAsFixed(2)
                          : '-'),
                  align: TextAlign.right,
                ),
                _td(item.total.toStringAsFixed(2),
                    align: TextAlign.right, isBold: true),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _th(String label, {TextAlign align = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Text(
        label,
        textAlign: align,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
            color: Color(0xFF334155)),
      ),
    );
  }

  Widget _td(String label,
      {TextAlign align = TextAlign.left, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Text(
        label,
        textAlign: align,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: const Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildTotalsAndSummarySection(bool isMobile) {
    final s = invoice.summary;

    final wordsAndBadgeWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(6),
            border: const Border(
                left: BorderSide(color: kcVoltSpareEVGreen, width: 4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AMOUNT IN WORDS',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 3),
              Text(
                s.amountInWords.isNotEmpty
                    ? s.amountInWords
                    : 'Indian Rupees Only',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: Color(0xFF0F172A)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFA7F3D0)),
          ),
          child: const Row(
            children: [
              Icon(Icons.verified_rounded, color: kcVoltSpareEVGreen, size: 15),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'GST Paid Tax Invoice verified under CGST / SGST / IGST Act 2017.',
                  style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF065F46),
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final totalsBoxWidget = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _summaryRow(
              'Taxable Base Value:', '₹${s.taxableAmount.toStringAsFixed(2)}'),
          if (s.isIntraState) ...[
            _summaryRow(
                'Central GST (CGST):', '₹${s.totalCgst.toStringAsFixed(2)}'),
            _summaryRow(
                'State GST (SGST):', '₹${s.totalSgst.toStringAsFixed(2)}'),
          ] else ...[
            _summaryRow(
                'Integrated GST (IGST):', '₹${s.totalIgst.toStringAsFixed(2)}'),
          ],
          _summaryRow(
              'Delivery / Shipping:',
              s.deliveryCharges > 0
                  ? '₹${s.deliveryCharges.toStringAsFixed(2)}'
                  : 'FREE',
              isGreen: s.deliveryCharges == 0),
          if (s.totalDiscount > 0)
            _summaryRow(
                'Discount Applied:', '-₹${s.totalDiscount.toStringAsFixed(2)}',
                isDiscount: true),
          const Divider(height: 14, color: Color(0xFF0F172A), thickness: 1.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grand Total:',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A)),
              ),
              Text(
                '₹${s.grandTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A)),
              ),
            ],
          ),
        ],
      ),
    );

    if (isMobile) {
      return Column(
        children: [
          totalsBoxWidget,
          const SizedBox(height: 12),
          wordsAndBadgeWidget,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: wordsAndBadgeWidget),
        const SizedBox(width: 16),
        Expanded(flex: 2, child: totalsBoxWidget),
      ],
    );
  }

  Widget _summaryRow(String label, String value,
      {bool isDiscount = false, bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDiscount
                  ? const Color(0xFFDC2626)
                  : (isGreen ? kcVoltSpareEVGreen : const Color(0xFF0F172A)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TERMS & CONDITIONS',
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 4),
        ...invoice.terms.map((t) => Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
                  Expanded(
                    child: Text(t,
                        style: const TextStyle(
                            fontSize: 10, color: Color(0xFF64748B))),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 14),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'For ${invoice.business.name}',
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 18),
              const Text(
                'Authorized Signatory',
                style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
