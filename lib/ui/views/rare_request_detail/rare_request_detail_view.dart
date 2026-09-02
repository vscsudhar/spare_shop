import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';

import 'rare_request_detail_viewmodel.dart';

class RareRequestDetailView extends StackedView<RareRequestDetailViewModel> {
  final String requestId;

  const RareRequestDetailView({
    Key? key,
    required this.requestId,
  }) : super(key: key);

  @override
  void onViewModelReady(RareRequestDetailViewModel viewModel) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => viewModel.init(requestId));
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    RareRequestDetailViewModel viewModel,
    Widget? child,
  ) {
    final req = viewModel.request;

    if (req == null) {
      return const Scaffold(
        appBar: VoltSpareAppBar(title: 'Request Details', showBackButton: true),
        body: Center(child: Text('Request details not found.')),
      );
    }

    return Scaffold(
      backgroundColor: kcVoltSpareOffWhite,
      appBar: VoltSpareAppBar(
        title: 'Request: #${req.id}',
        showBackButton: true,
        onBackPressed: viewModel.goBack,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Panel
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
                          const Text('CURRENT STATUS',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            req.status.name.toUpperCase(),
                            style: TextStyle(
                              color: viewModel.getStatusColor(req.status),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        viewModel.getStatusDescription(req.status),
                        style: const TextStyle(fontSize: 13, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Spare Part Description
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('SPARE PART SPECIFICATIONS',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      _specRow('Part Name',
                          req.partName ?? 'Unknown / Unspecified spare part'),
                      _specRow('Description', req.description),
                      _specRow('Vehicle Compat.', req.vehicle.displayName),
                      _specRow('Quantity Required', '${req.quantity} Units'),
                      _specRow('Urgency Priority', req.urgency),
                      if (req.budget != null)
                        _specRow('Target Budget',
                            '₹${req.budget!.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Attachment Preview
              if (req.images.isNotEmpty) ...[
                const Text('ATTACHED IMAGES',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: req.images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: kcVoltSpareBorder),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Actions
              ElevatedButton.icon(
                onPressed: () => viewModel.goToChat(requestId),
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                label: const Text('Open Support Conversation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kcVoltSpareDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
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
            width: 120,
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

  @override
  RareRequestDetailViewModel viewModelBuilder(BuildContext context) =>
      RareRequestDetailViewModel();
}
