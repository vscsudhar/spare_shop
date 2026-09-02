import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/app/app.router.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/rare_request_service.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class RequestCancelledViewModel extends BaseViewModel with NavigationMixin {
  final _rareRequestService = locator<RareRequestService>();
  String? _loadedRequestId;
  bool _isInitialLoading = false;
  bool _initialDataLoaded = false;
  bool _isActionSubmitting = false;

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

  Future<void> reopen() async {
    if (_isActionSubmitting) return;
    _isActionSubmitting = true;
    setBusy(true);

    try {
      await _rareRequestService.reopenRequest(_requestId);
      navigationService.navigateTo(
        Routes.requestChatQuotationView,
        arguments: RequestChatQuotationViewArguments(requestId: _requestId),
      );
    } catch (_) {
    } finally {
      _isActionSubmitting = false;
      setBusy(false);
    }
  }

  void chatWithAdmin() {
    navigationService.navigateTo(
      Routes.requestChatQuotationView,
      arguments: RequestChatQuotationViewArguments(requestId: _requestId),
    );
  }

  Future<void> requestRevisedQuotation() async {
    await reopen();
  }
}
