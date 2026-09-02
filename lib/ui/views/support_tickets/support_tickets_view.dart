import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/responsive.dart';
import 'package:spare_shop/ui/common/support_ticket_models.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';

import 'support_tickets_viewmodel.dart';

class SupportTicketsView extends StackedView<SupportTicketsViewModel> {
  const SupportTicketsView({Key? key}) : super(key: key);

  @override
  void onViewModelReady(SupportTicketsViewModel viewModel) {
    WidgetsBinding.instance.addPostFrameCallback((_) => viewModel.init());
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    SupportTicketsViewModel viewModel,
    Widget? child,
  ) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Scaffold(
          backgroundColor: kcVoltSpareOffWhite,
          appBar: VoltSpareAppBar(
            title: 'Support Tickets',
            showBackButton: true,
            onBackPressed: viewModel.goBack,
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded,
                    color: kcVoltSpareDark),
                tooltip: 'Create Ticket',
                onPressed: () => viewModel.openCreateTicket(context),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => viewModel.openCreateTicket(context),
            backgroundColor: kcVoltSpareDark,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: const Text(
              'New Ticket',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SafeArea(
            child: MaxContentWidth(
              maxWidth: 900,
              child: RefreshIndicator(
                color: kcVoltSpareEVGreen,
                onRefresh: viewModel.loadTickets,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filter Chips Bar
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      color: kcVoltSpareWhite,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['All', 'Open', 'Pending', 'Resolved']
                              .map((filter) {
                            final isSelected =
                                viewModel.selectedFilter == filter;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(filter),
                                selected: isSelected,
                                onSelected: (_) =>
                                    viewModel.setFilter(filter),
                                selectedColor: kcVoltSpareDark,
                                backgroundColor: kcVoltSpareOffWhite,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : kcVoltSpareTextPrimary,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  fontSize: 13,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: isSelected
                                        ? kcVoltSpareDark
                                        : kcVoltSpareBorder,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const Divider(height: 1, color: kcVoltSpareBorder),

                    // Main Tickets List
                    Expanded(
                      child: viewModel.isBusy
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: kcVoltSpareEVGreen),
                            )
                          : viewModel.filteredTickets.isEmpty
                              ? _buildEmptyState(context, viewModel)
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: viewModel.filteredTickets.length,
                                  itemBuilder: (context, index) {
                                    final ticket =
                                        viewModel.filteredTickets[index];
                                    return _buildTicketCard(
                                        context, viewModel, ticket);
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
      BuildContext context, SupportTicketsViewModel viewModel) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 80),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kcVoltSpareEVGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  size: 54,
                  color: kcVoltSpareEVGreen,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'No Support Tickets',
                style: TextStyle(
                  color: kcVoltSpareTextPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Have a question or issue? Create a support ticket\nand our team will assist you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kcVoltSpareTextSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => viewModel.openCreateTicket(context),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Create Support Ticket'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kcVoltSpareDark,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTicketCard(
    BuildContext context,
    SupportTicketsViewModel viewModel,
    SupportTicketModel ticket,
  ) {
    final status = ticket.status;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: kcVoltSpareWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kcVoltSpareBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => viewModel.openTicketChat(ticket),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Ticket Number & Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '#${ticket.ticketNumber}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: kcVoltSpareDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: kcVoltSpareOffWhite,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: kcVoltSpareBorder),
                          ),
                          child: Text(
                            ticket.category,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: kcVoltSpareTextSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
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

                const SizedBox(height: 10),

                // Subject
                Text(
                  ticket.subject,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: kcVoltSpareTextPrimary,
                  ),
                ),

                const SizedBox(height: 4),

                // Description snippet
                Text(
                  ticket.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kcVoltSpareTextSecondary,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 12),

                // Footer Row: Photos Pill & Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (ticket.photos.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.photo_library_outlined,
                              size: 14, color: kcVoltSpareTextSecondary),
                          const SizedBox(width: 4),
                          Text(
                            '${ticket.photos.length} photo${ticket.photos.length > 1 ? 's' : ''}',
                            style: const TextStyle(
                              color: kcVoltSpareTextSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      )
                    else
                      const SizedBox.shrink(),
                    Row(
                      children: [
                        Text(
                          '${ticket.createdAt.day}/${ticket.createdAt.month}/${ticket.createdAt.year}',
                          style: const TextStyle(
                            color: kcVoltSpareTextSecondary,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: kcVoltSpareTextSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  SupportTicketsViewModel viewModelBuilder(BuildContext context) =>
      SupportTicketsViewModel();
}
