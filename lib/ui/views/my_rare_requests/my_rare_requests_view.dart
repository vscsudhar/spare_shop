import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';

import 'my_rare_requests_viewmodel.dart';

class MyRareRequestsView extends StackedView<MyRareRequestsViewModel> {
  const MyRareRequestsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    MyRareRequestsViewModel viewModel,
    Widget? child,
  ) {
    final filters = [
      'All',
      'Searching',
      'Quote Received',
      'Approved',
      'Cancelled'
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        viewModel.goBack();
      },
      child: Scaffold(
        backgroundColor: kcVoltSpareOffWhite,
        appBar: VoltSpareAppBar(
          title: 'My Rare Spares Requests',
          showBackButton: true,
          onBackPressed: viewModel.goBack,
        ),
        body: SafeArea(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  // Filter Chips Scrollable Row
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      itemCount: filters.length,
                      itemBuilder: (context, index) {
                        final f = filters[index];
                        final isSelected = viewModel.selectedFilter == f;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(
                              f,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (_) => viewModel.setFilter(f),
                            selectedColor: kcVoltSpareDark,
                            backgroundColor: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),

                  // Requests Feed
                  Expanded(
                    child: viewModel.requests.isEmpty
                        ? const Center(
                            child: Text(
                              'No rare requests found matching this status.',
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: viewModel.requests.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final r = viewModel.requests[index];
                              return _buildRequestCard(viewModel, r);
                            },
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => viewModel.goToCreateRequest(),
          backgroundColor: kcVoltSpareDark,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text(
            'Request Rare Part',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(
      MyRareRequestsViewModel vm, RareProductRequestModel r) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: kcVoltSpareBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'REF: #${r.id}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.grey),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(r.status).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    r.status.name.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(r.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            Text(
              r.partName ?? 'Unknown Spare Part',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              'Vehicle: ${r.vehicle.displayName}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Text(
              r.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, height: 1.4),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Submitted: ${r.date.toString().substring(0, 10)}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                ElevatedButton(
                  onPressed: () => vm.goToRequestDetail(r.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kcVoltSpareDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('View Request'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(RareRequestStatus status) {
    switch (status) {
      case RareRequestStatus.submitted:
        return Colors.blue;
      case RareRequestStatus.searching:
        return Colors.orange;
      case RareRequestStatus.found:
      case RareRequestStatus.quotationSent:
        return Colors.teal;
      case RareRequestStatus.negotiation:
        return Colors.purple;
      case RareRequestStatus.approved:
      case RareRequestStatus.convertedToOrder:
        return Colors.green;
      case RareRequestStatus.cancelled:
        return Colors.red;
    }
  }

  @override
  MyRareRequestsViewModel viewModelBuilder(BuildContext context) =>
      MyRareRequestsViewModel();
}
