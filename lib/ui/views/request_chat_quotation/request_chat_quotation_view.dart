import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';

import 'request_chat_quotation_viewmodel.dart';

class RequestChatQuotationView
    extends StackedView<RequestChatQuotationViewModel> {
  final String requestId;

  const RequestChatQuotationView({
    Key? key,
    required this.requestId,
  }) : super(key: key);

  @override
  void onViewModelReady(RequestChatQuotationViewModel viewModel) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => viewModel.init(requestId));
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    RequestChatQuotationViewModel viewModel,
    Widget? child,
  ) {
    final req = viewModel.request;

    if (req == null) {
      return const Scaffold(
        body: Center(child: Text('Request not found.')),
      );
    }

    return Scaffold(
      backgroundColor: kcVoltSpareOffWhite,
      appBar: VoltSpareAppBar(
        title: 'Rare Support: #${req.id}',
        showBackButton: true,
        onBackPressed: viewModel.goBack,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                // Top Request Summary Bar (Collapsible)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                kcVoltSpareDark.withValues(alpha: 0.08),
                            child: const Icon(Icons.build_circle_rounded,
                                color: kcVoltSpareDark),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(req.partName ?? 'Unknown Spare Part',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                                const SizedBox(height: 2),
                                Text('Vehicle: ${req.vehicle.displayName}',
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              viewModel.showSummaryDetails
                                  ? Icons.expand_less_rounded
                                  : Icons.expand_more_rounded,
                              color: kcVoltSpareDark,
                              size: 20,
                            ),
                            onPressed: viewModel.toggleSummaryDetails,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(req.status)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              req.status.name.toUpperCase(),
                              style: TextStyle(
                                color: _getStatusColor(req.status),
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          )
                        ],
                      ),
                      if (viewModel.showSummaryDetails) ...[
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text('Description:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Colors.grey)),
                        const SizedBox(height: 2),
                        Text(req.description,
                            style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _summaryField('Quantity', '${req.quantity} Units'),
                            _summaryField('Urgency', req.urgency),
                          ],
                        ),
                        if (req.images.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          const Text('Reference Images:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Colors.grey)),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: req.images.length,
                              itemBuilder: (context, idx) {
                                return Container(
                                  width: 60,
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border:
                                        Border.all(color: kcVoltSpareBorder),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(
                                      req.images[idx],
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => const Icon(
                                          Icons.broken_image,
                                          size: 16),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Chat Messages Feed
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.messages.length,
                    itemBuilder: (context, index) {
                      final message = viewModel.messages[index];

                      if (message.messageType ==
                          RareChatMessageType.statusUpdate) {
                        return _buildSystemMessage(message.message);
                      }

                      final quotation = message.quotation ??
                          (message.messageType == RareChatMessageType.quotation
                              ? viewModel.request?.quotation
                              : null);
                      if (message.messageType ==
                              RareChatMessageType.quotation &&
                          quotation != null) {
                        return _buildQuotationMessageCard(
                            context, viewModel, quotation);
                      }

                      final isMe = message.sender == RareChatSender.customer;
                      return _buildChatBubble(message, isMe);
                    },
                  ),
                ),

                // Input Composer
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: kcVoltSpareBorder)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_photo_alternate_rounded,
                            color: kcVoltSpareEVGreen, size: 24),
                        onPressed: viewModel.uploadChatImage,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: TextField(
                          controller: viewModel.messageController,
                          decoration: InputDecoration(
                            hintText: 'Ask support about this spare...',
                            filled: true,
                            fillColor: kcVoltSpareOffWhite,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (_) => viewModel.sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: kcVoltSpareDark,
                        child: IconButton(
                          icon: const Icon(Icons.send_rounded,
                              color: Colors.white, size: 18),
                          onPressed: viewModel.sendMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatBubble(RareChatMessageModel msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? kcVoltSpareDark : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
          border: isMe ? null : Border.all(color: kcVoltSpareBorder),
        ),
        constraints: const BoxConstraints(maxWidth: 260),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (msg.images != null && msg.images!.isNotEmpty) ...[
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: msg.images!.length,
                  itemBuilder: (context, idx) {
                    return Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 8, bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: isMe ? Colors.white30 : kcVoltSpareBorder),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          msg.images![idx],
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Icon(
                            Icons.broken_image,
                            color: isMe ? Colors.white60 : Colors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            Text(
              msg.message,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: isMe ? Colors.white60 : Colors.grey,
                      fontSize: 9,
                    ),
                  ),
                  if (isMe) _buildStatusTicks(msg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTicks(RareChatMessageModel msg) {
    if (msg.id.startsWith('temp_')) {
      return const Padding(
        padding: EdgeInsets.only(left: 4.0),
        child: Icon(
          Icons.access_time_rounded,
          size: 10,
          color: Colors.white60,
        ),
      );
    }

    if (msg.readBy.length > 1) {
      return const Padding(
        padding: EdgeInsets.only(left: 4.0),
        child: Icon(
          Icons.done_all_rounded,
          size: 12,
          color: Colors.lightBlueAccent,
        ),
      );
    } else if (msg.receivedBy.length > 1) {
      return const Padding(
        padding: EdgeInsets.only(left: 4.0),
        child: Icon(
          Icons.done_all_rounded,
          size: 12,
          color: Colors.white60,
        ),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.only(left: 4.0),
        child: Icon(
          Icons.check_rounded,
          size: 12,
          color: Colors.white60,
        ),
      );
    }
  }

  Widget _summaryField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
        Text(value,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildSystemMessage(String msg) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: kcVoltSpareEVGreen.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kcVoltSpareEVGreen.withValues(alpha: 0.3)),
        ),
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: kcVoltSpareEVGreen,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildQuotationMessageCard(BuildContext context,
      RequestChatQuotationViewModel vm, RareQuotationModel q) {
    final isPending = q.status == 'pending' || q.status == 'sent';

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: kcVoltSpareEVGreen, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.receipt_long, color: kcVoltSpareEVGreen, size: 20),
                SizedBox(width: 8),
                Text(
                  'Pricing Quotation Received',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: kcVoltSpareEVGreen),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(q.partName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            if (q.adminNotes != null)
              Text('Notes: ${q.adminNotes}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 12),
            _priceRow('Unit Price', '₹${q.price.toStringAsFixed(2)}'),
            _priceRow('Shipping', '₹${q.shippingCharge.toStringAsFixed(2)}'),
            _priceRow('Tax/GST (18%)', '₹${q.gst.toStringAsFixed(2)}'),
            _priceRow('Discount Applied', '-₹${q.discount.toStringAsFixed(2)}',
                color: Colors.green),
            const Divider(),
            _priceRow('Grand Total', '₹${q.grandTotal.toStringAsFixed(2)}',
                isBold: true),
            const SizedBox(height: 16),
            if (isPending)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: vm.cancelQuotation,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: vm.approveQuotation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kcVoltSpareEVGreen,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Approve'),
                    ),
                  ),
                ],
              )
            else
              Center(
                child: Text(
                  q.status == 'approved' ? 'APPROVED' : 'DECLINED',
                  style: TextStyle(
                    color: q.status == 'approved' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: vm.goToQuotationDetail,
              child: const Text('View Quotation Contract details',
                  style: TextStyle(fontSize: 12)),
            )
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: color)),
        ],
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
  RequestChatQuotationViewModel viewModelBuilder(BuildContext context) =>
      RequestChatQuotationViewModel();
}
