import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/rare_request_service.dart';
import 'package:spare_shop/core/services/socket_service.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class MyRareRequestsViewModel extends FutureViewModel<void>
    with NavigationMixin {
  final _rareRequestService = locator<RareRequestService>();
  final _socketService = locator<SocketService>();

  Function(dynamic)? _onUpdatedHandler;
  Function(dynamic)? _onNewHandler;

  String _selectedFilter = 'All';
  String get selectedFilter => _selectedFilter;

  List<RareProductRequestModel> _allRequests = [];

  List<RareProductRequestModel> get requests {
    if (_selectedFilter == 'All') return _allRequests;

    return _allRequests.where((r) {
      if (_selectedFilter == 'Searching') {
        return r.status == RareRequestStatus.searching ||
            r.status == RareRequestStatus.submitted;
      }
      if (_selectedFilter == 'Quote Received') {
        return r.status == RareRequestStatus.quotationSent ||
            r.status == RareRequestStatus.negotiation;
      }
      if (_selectedFilter == 'Approved') {
        return r.status == RareRequestStatus.approved ||
            r.status == RareRequestStatus.convertedToOrder;
      }
      if (_selectedFilter == 'Cancelled') {
        return r.status == RareRequestStatus.cancelled;
      }
      return true;
    }).toList();
  }

  @override
  Future<void> futureToRun() async {
    _socketService.connect();
    _onUpdatedHandler = (data) {
      if (!disposed) loadRequests();
    };
    _onNewHandler = (data) {
      if (!disposed) loadRequests();
    };
    _socketService.on('rare_request:updated', _onUpdatedHandler!);
    _socketService.on('rare_request:new', _onNewHandler!);
    await loadRequests();
  }

  Future<void> loadRequests() async {
    if (disposed) return;
    try {
      _allRequests = await _rareRequestService.getMyRequests();
      if (!disposed) rebuildUi();
    } catch (_) {}
  }

  void setFilter(String val) {
    _selectedFilter = val;
    notifyListeners();
  }

  Future<void> goToRequestDetail(String id) async {
    await goToRequestChatQuotation(requestId: id);
    if (!disposed) {
      await loadRequests();
    }
  }

  Future<void> goToCreateRequest([BuildContext? context]) async {
    if (context != null) {
      final isAuth =
          await ensureAuthenticated(context, featureName: 'Rare Requests');
      if (!isAuth) return;
    }
    final result = await goToRareProductRequest();
    if (result == true && !disposed) {
      await loadRequests();
    }
  }

  @override
  void goBack() {
    clearStackAndShowHome();
  }

  @override
  void dispose() {
    if (_onUpdatedHandler != null) {
      _socketService.off('rare_request:updated', _onUpdatedHandler);
    }
    if (_onNewHandler != null) {
      _socketService.off('rare_request:new', _onNewHandler);
    }
    super.dispose();
  }
}
