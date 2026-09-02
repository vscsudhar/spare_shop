import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/app/app.router.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/rare_request_service.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class QuotationApprovedViewModel extends BaseViewModel with NavigationMixin {
  final _rareRequestService = locator<RareRequestService>();
  String? _loadedRequestId;
  bool _isInitialLoading = false;
  bool _initialDataLoaded = false;

  late String _requestId;

  RareProductRequestModel? _request;
  RareProductRequestModel? get request => _request;

  void init(String reqId) async {
    if (_isInitialLoading ||
        (_loadedRequestId == reqId && _initialDataLoaded)) {
      return;
    }

    _isInitialLoading = true;
    _loadedRequestId = reqId;
    _requestId = reqId;

    setBusy(true);
    try {
      _request = await _rareRequestService.getRequestById(_requestId);
      _initialDataLoaded = true;
      rebuildUi();
    } catch (_) {
    } finally {
      _isInitialLoading = false;
      setBusy(false);
    }
  }

  void goHome() {
    clearStackAndShowHome();
  }

  void viewMyRequests() {
    navigationService.navigateTo(Routes.myRareRequestsView);
  }

  void chatWithAdmin() {
    navigationService.navigateTo(
      Routes.requestChatQuotationView,
      arguments: RequestChatQuotationViewArguments(requestId: _requestId),
    );
  }
}
