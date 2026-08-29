import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/rare_request_service.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class MyRareRequestsViewModel extends FutureViewModel<void>
    with NavigationMixin {
  final _rareRequestService = locator<RareRequestService>();

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
    await loadRequests();
  }

  Future<void> loadRequests() async {
    try {
      _allRequests = await _rareRequestService.getMyRequests();
      rebuildUi();
    } catch (_) {}
  }

  void setFilter(String val) {
    _selectedFilter = val;
    notifyListeners();
  }

  void goToRequestDetail(String id) {
    goToRequestChatQuotation(requestId: id);
  }

  void goToCreateRequest() async {
    final result = await goToRareProductRequest();
    if (result == true) {
      await loadRequests();
    }
  }

  @override
  void goBack() {
    clearStackAndShowHome();
  }
}
