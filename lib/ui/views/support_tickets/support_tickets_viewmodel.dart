import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/support_ticket_service.dart';
import 'package:spare_shop/ui/common/support_ticket_models.dart';
import 'package:stacked/stacked.dart';

class SupportTicketsViewModel extends BaseViewModel with NavigationMixin {
  final _ticketService = locator<SupportTicketService>();

  String _selectedFilter = 'All';
  String get selectedFilter => _selectedFilter;

  List<SupportTicketModel> _tickets = [];
  List<SupportTicketModel> get tickets => _tickets;

  List<SupportTicketModel> get filteredTickets {
    if (_selectedFilter == 'All') return _tickets;
    return _tickets.where((t) => t.status.name.toLowerCase() == _selectedFilter.toLowerCase()).toList();
  }

  void _onTicketsChanged() {
    _tickets = _ticketService.cachedTickets;
    rebuildUi();
  }

  Future<void> init() async {
    _ticketService.ticketsNotifier.removeListener(_onTicketsChanged);
    _ticketService.ticketsNotifier.addListener(_onTicketsChanged);
    await loadTickets();
  }

  Future<void> loadTickets() async {
    setBusy(true);
    try {
      _tickets = await _ticketService.getMyTickets();
    } catch (_) {}
    setBusy(false);
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    rebuildUi();
  }

  Future<void> openCreateTicket([BuildContext? context]) async {
    if (context != null) {
      final isAuth = await ensureAuthenticated(context,
          featureName: 'Create Support Ticket');
      if (!isAuth) return;
    }
    await goToCreateTicket();
    await loadTickets();
  }

  void openTicketChat(SupportTicketModel ticket) async {
    await goToTicketChat(ticket: ticket);
    await loadTickets();
  }

  @override
  void dispose() {
    _ticketService.ticketsNotifier.removeListener(_onTicketsChanged);
    super.dispose();
  }
}
