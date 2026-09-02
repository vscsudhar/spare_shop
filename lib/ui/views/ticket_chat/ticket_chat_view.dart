import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spare_shop/core/services/api_endpoints.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/responsive.dart';
import 'package:spare_shop/ui/common/support_ticket_models.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';

import 'ticket_chat_viewmodel.dart';

class TicketChatView extends StackedView<TicketChatViewModel> {
  final SupportTicketModel ticket;

  const TicketChatView({Key? key, required this.ticket}) : super(key: key);

  @override
  void onViewModelReady(TicketChatViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    TicketChatViewModel viewModel,
    Widget? child,
  ) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final currentTicket = viewModel.ticket;
        final status = currentTicket.status;

        return Scaffold(
          backgroundColor: kcVoltSpareOffWhite,
          appBar: VoltSpareAppBar(
            title: '#${currentTicket.ticketNumber}',
            showBackButton: true,
            onBackPressed: viewModel.goBack,
            actions: [
              if (status == TicketStatus.resolved)
                TextButton(
                  onPressed: viewModel.reopenTicket,
                  child: const Text(
                    'Reopen',
                    style: TextStyle(
                      color: Color(0xFF0070F3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                TextButton(
                  onPressed: viewModel.markAsResolved,
                  child: const Text(
                    'Resolve',
                    style: TextStyle(
                      color: kcVoltSpareEVGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          body: SafeArea(
            child: MaxContentWidth(
              maxWidth: 900,
              child: Column(
                children: [
                  // Ticket Summary Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      color: kcVoltSpareWhite,
                      border:
                          Border(bottom: BorderSide(color: kcVoltSpareBorder)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentTicket.subject,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: kcVoltSpareDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Category: ${currentTicket.category}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: kcVoltSpareTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: status.backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status.displayName,
                            style: TextStyle(
                              color: status.color,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Chat Message List
                  Expanded(
                    child: viewModel.isBusy
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: kcVoltSpareEVGreen),
                          )
                        : ListView.builder(
                            controller: viewModel.scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: viewModel.messages.length,
                            itemBuilder: (context, index) {
                              final message = viewModel.messages[index];
                              return _buildMessageBubble(context, message);
                            },
                          ),
                  ),

                  // Selected photos preview above input bar
                  if (viewModel.selectedPhotos.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      color: kcVoltSpareWhite,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: viewModel.selectedPhotos
                              .asMap()
                              .entries
                              .map((entry) {
                            final idx = entry.key;
                            final photo = entry.value;
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: kcVoltSpareBorder),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(9),
                                    child: kIsWeb
                                        ? Image.network(
                                            photo.path,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(photo.path),
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: GestureDetector(
                                      onTap: () => viewModel.removePhoto(idx),
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                  // Chat Input Bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: const BoxDecoration(
                      color: kcVoltSpareWhite,
                      border: Border(top: BorderSide(color: kcVoltSpareBorder)),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.photo_library_outlined,
                              color: kcVoltSpareTextSecondary),
                          tooltip: 'Attach Photo',
                          onPressed: viewModel.pickPhoto,
                        ),
                        IconButton(
                          icon: const Icon(Icons.camera_alt_outlined,
                              color: kcVoltSpareTextSecondary),
                          tooltip: 'Take Photo',
                          onPressed: viewModel.capturePhoto,
                        ),
                        Expanded(
                          child: TextField(
                            controller: viewModel.messageController,
                            maxLines: null,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              hintStyle: const TextStyle(
                                color: kcLightGrey,
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: kcVoltSpareOffWhite,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: const BoxDecoration(
                            color: kcVoltSpareDark,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: viewModel.isSending
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.send_rounded,
                                    color: Colors.white, size: 18),
                            onPressed:
                                viewModel.isSending ? null : viewModel.sendMessage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(BuildContext context, TicketMessageModel message) {
    final isCustomer = message.isCustomer;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment:
            isCustomer ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCustomer) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: kcVoltSpareDark,
              child: Icon(Icons.support_agent,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isCustomer ? kcVoltSpareDark : kcVoltSpareWhite,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isCustomer ? 18 : 4),
                  bottomRight: Radius.circular(isCustomer ? 4 : 18),
                ),
                border: isCustomer
                    ? null
                    : Border.all(color: kcVoltSpareBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: isCustomer
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (!isCustomer) ...[
                    Text(
                      message.senderName,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: kcVoltSpareEVGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],

                  // Text message
                  if (message.message.isNotEmpty)
                    Text(
                      message.message,
                      style: TextStyle(
                        color: isCustomer
                            ? Colors.white
                            : kcVoltSpareTextPrimary,
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),

                  // Image attachments
                  if (message.attachments.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: message.attachments.map((att) {
                        final fullUrl = att.url.startsWith('http')
                            ? att.url
                            : '${ApiEndpoints.socketUrl}${att.url}';
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            fullUrl,
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 140,
                              height: 140,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.broken_image,
                                  color: Colors.grey),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 4),

                  // Time
                  Text(
                    '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: isCustomer
                          ? Colors.white.withValues(alpha: 0.6)
                          : kcVoltSpareTextSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isCustomer) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: kcVoltSpareEVGreen,
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ],
        ],
      ),
    );
  }

  @override
  TicketChatViewModel viewModelBuilder(BuildContext context) =>
      TicketChatViewModel(initialTicket: ticket);
}
