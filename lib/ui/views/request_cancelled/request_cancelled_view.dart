import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'request_cancelled_viewmodel.dart';

class RequestCancelledView extends StackedView<RequestCancelledViewModel> {
  final String requestId;

  const RequestCancelledView({
    Key? key,
    required this.requestId,
  }) : super(key: key);

  @override
  void onViewModelReady(RequestCancelledViewModel viewModel) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => viewModel.init(requestId));
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    RequestCancelledViewModel viewModel,
    Widget? child,
  ) {
    final req = viewModel.request;

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
                      color: Colors.red.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cancel_rounded,
                      color: Colors.red,
                      size: 56,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Request Cancelled',
                    style: TextStyle(
                      color: kcVoltSpareTextPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  if (req != null) ...[
                    Text('Request REF: #${req.id}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.grey)),
                    if (req.cancellationReason != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Reason: "${req.cancellationReason}"',
                        style: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                  const SizedBox(height: 16),
                  const Text(
                    'The rare product request quotation has been declined. You can reopen the request to renegotiate or revise details.',
                    style: TextStyle(
                      color: kcVoltSpareTextSecondary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: viewModel.reopen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kcVoltSpareDark,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Reopen Request'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: viewModel.chatWithAdmin,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kcVoltSpareDark,
                      side: const BorderSide(color: kcVoltSpareBorder),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Chat with Admin Support'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: viewModel.requestRevisedQuotation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Request Revised Quotation'),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: viewModel.goHome,
                    child: const Text('Back to Home'),
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
  RequestCancelledViewModel viewModelBuilder(BuildContext context) =>
      RequestCancelledViewModel();
}
