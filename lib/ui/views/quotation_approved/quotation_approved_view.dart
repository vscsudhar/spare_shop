import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'quotation_approved_viewmodel.dart';

class QuotationApprovedView extends StackedView<QuotationApprovedViewModel> {
  final String requestId;

  const QuotationApprovedView({
    Key? key,
    required this.requestId,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    QuotationApprovedViewModel viewModel,
    Widget? child,
  ) {
    viewModel.init(requestId);
    final req = viewModel.request;
    final q = req?.quotation;

    return Scaffold(
      backgroundColor: kcVoltSpareOffWhite,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 450),
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: kcVoltSpareEVGreen.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.assignment_turned_in_rounded,
                      color: kcVoltSpareEVGreen,
                      size: 56,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Quotation Approved!',
                    style: TextStyle(
                      color: kcVoltSpareTextPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (req != null) ...[
                    Text('Request REF: #${req.id}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.grey)),
                    const SizedBox(height: 8),
                    if (q != null) ...[
                      Text(
                          'Approved Grand Total: ₹${q.grandTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text('Est. Delivery Timeline: ${q.deliveryTimeline}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      req.status.name == 'convertedToOrder'
                          ? 'Request converted to Order #VS-${req.id}'
                          : 'Admin will convert this request into a standard checkout order shortly.',
                      style: const TextStyle(
                          color: kcVoltSpareTextSecondary,
                          fontSize: 13,
                          height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: viewModel.chatWithAdmin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kcVoltSpareDark,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Chat with Support'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: viewModel.viewMyRequests,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kcVoltSpareDark,
                      side: const BorderSide(color: kcVoltSpareBorder),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('View My Rare Requests'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: viewModel.goHome,
                    child: const Text('Continue Shopping'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  QuotationApprovedViewModel viewModelBuilder(BuildContext context) =>
      QuotationApprovedViewModel();
}
