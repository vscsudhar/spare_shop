import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';

import 'customer_quotation_viewmodel.dart';

class CustomerQuotationView extends StackedView<CustomerQuotationViewModel> {
  final String requestId;
  final String quotationId;

  const CustomerQuotationView({
    Key? key,
    required this.requestId,
    required this.quotationId,
  }) : super(key: key);

  @override
  void onViewModelReady(CustomerQuotationViewModel viewModel) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => viewModel.init(requestId, quotationId));
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    CustomerQuotationViewModel viewModel,
    Widget? child,
  ) {
    final q = viewModel.quotation;

    if (q == null) {
      return const Scaffold(
        body: Center(child: Text('Quotation not found.')),
      );
    }

    final isPending = q.status == 'pending';

    return Scaffold(
      backgroundColor: kcVoltSpareOffWhite,
      appBar: VoltSpareAppBar(
        title: 'Quotation Details',
        showBackButton: true,
        onBackPressed: viewModel.goBack,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Contract Summary
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('CONTRACT REFERENCE',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            q.status.toUpperCase(),
                            style: TextStyle(
                              color: q.status == 'approved'
                                  ? Colors.green
                                  : (q.status == 'declined'
                                      ? Colors.red
                                      : Colors.orange),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(q.partName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      if (q.adminNotes != null)
                        Text('Admin Note: ${q.adminNotes}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Pricing Breakdown
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('PRICING BREAKDOWN',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      _pricingRow('Spare Base Unit Price',
                          '₹${q.price.toStringAsFixed(2)}'),
                      _pricingRow('Warehouse Shipping & Courier',
                          '₹${q.shippingCharge.toStringAsFixed(2)}'),
                      _pricingRow('CGST / SGST Taxes (18%)',
                          '₹${q.gst.toStringAsFixed(2)}'),
                      _pricingRow('VoltSpare Member Discount',
                          '-₹${q.discount.toStringAsFixed(2)}',
                          color: Colors.green),
                      const Divider(height: 24),
                      _pricingRow('Grand Total Amount',
                          '₹${q.grandTotal.toStringAsFixed(2)}',
                          isBold: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Timeline Terms
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('DELIVERY LOGISTICS & TERMS',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      _specRow('Est. Delivery', q.deliveryTimeline),
                      _specRow('Expiry Date',
                          q.expiryDate.toString().substring(0, 10)),
                      _specRow('T&C Policy',
                          'Price holds valid until expiry date. Returns accepted on compatibility mismatches.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Pending Actions
              if (isPending)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            _showDeclineReasonDialog(context, viewModel),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Decline Quotation'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            _showApproveConfirmDialog(context, viewModel),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kcVoltSpareEVGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Approve & Accept'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pricingRow(String label, String val,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(val,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: color)),
        ],
      ),
    );
  }

  Widget _specRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.grey)),
          ),
          Expanded(
            child: Text(val,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  void _showApproveConfirmDialog(
      BuildContext context, CustomerQuotationViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Quotation Approval'),
          content: Text(
              'Are you sure you want to approve this quotation for ₹${viewModel.quotation?.grandTotal.toStringAsFixed(2)}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                viewModel.approve();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: kcVoltSpareEVGreen,
                  foregroundColor: Colors.white),
              child: const Text('Yes, Approve'),
            )
          ],
        );
      },
    );
  }

  void _showDeclineReasonDialog(
      BuildContext context, CustomerQuotationViewModel viewModel) {
    final otherController = TextEditingController();
    String selectedReason = 'Price is too high';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Cancel Request'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Please select a cancellation reason:',
                        style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 12),
                    ...[
                      'Price is too high',
                      'Product does not match',
                      'Delivery takes too long',
                      'Found elsewhere',
                      'No longer required',
                      'Other'
                    ].map((reason) {
                      return RadioListTile<String>(
                        value: reason,
                        groupValue: selectedReason,
                        title:
                            Text(reason, style: const TextStyle(fontSize: 12)),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              selectedReason = val;
                            });
                          }
                        },
                      );
                    }).toList(),
                    if (selectedReason == 'Other') ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: otherController,
                        decoration: const InputDecoration(
                          hintText: 'Describe details here...',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(8),
                        ),
                      )
                    ]
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final reason = selectedReason == 'Other'
                        ? otherController.text
                        : selectedReason;
                    Navigator.pop(context);
                    viewModel.cancel(reason);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white),
                  child: const Text('Confirm Cancellation'),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  CustomerQuotationViewModel viewModelBuilder(BuildContext context) =>
      CustomerQuotationViewModel();
}
