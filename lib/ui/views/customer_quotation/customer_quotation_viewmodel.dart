import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/app/app.router.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/address_service.dart';
import 'package:spare_shop/core/services/rare_request_service.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class CustomerQuotationViewModel extends BaseViewModel with NavigationMixin {
  final _rareRequestService = locator<RareRequestService>();
  final _addressService = locator<AddressService>();

  String? _loadedKey;
  bool _isInitialLoading = false;
  bool _initialDataLoaded = false;
  bool _isActionSubmitting = false;

  late String _requestId;
  late String _quotationId;

  String get requestId => _requestId;
  String get quotationId => _quotationId;

  RareProductRequestModel? _request;
  RareProductRequestModel? get request => _request;

  RareQuotationModel? get quotation => _request?.quotation;

  void init(String reqId, String qId) async {
    final key = '$reqId:$qId';
    if (_isInitialLoading || (_loadedKey == key && _initialDataLoaded)) {
      return;
    }

    _isInitialLoading = true;
    _loadedKey = key;
    _requestId = reqId;
    _quotationId = qId;

    setBusy(true);
    try {
      _request = await _rareRequestService.getRequestById(reqId);
      _initialDataLoaded = true;
      rebuildUi();
    } catch (_) {
    } finally {
      _isInitialLoading = false;
      setBusy(false);
    }
  }

  Future<void> approve() async {
    if (_isActionSubmitting) return;
    _isActionSubmitting = true;
    setBusy(true);

    try {
      String addressId = 'default';
      final addresses = await _addressService.getAddresses();
      if (addresses.isNotEmpty) {
        addressId = addresses
            .firstWhere((a) => a.isDefault, orElse: () => addresses.first)
            .id;
      }
      await _rareRequestService.customerApproveQuotation(
          _requestId, _quotationId, addressId);

      navigationService.navigateTo(
        Routes.quotationApprovedView,
        arguments: QuotationApprovedViewArguments(requestId: _requestId),
      );
    } catch (_) {
    } finally {
      _isActionSubmitting = false;
      setBusy(false);
    }
  }

  Future<void> cancel(String reason) async {
    if (_isActionSubmitting) return;
    _isActionSubmitting = true;
    setBusy(true);

    try {
      await _rareRequestService.customerDeclineQuotation(
          _requestId, _quotationId, reason);

      navigationService.navigateTo(
        Routes.requestCancelledView,
        arguments: RequestCancelledViewArguments(requestId: _requestId),
      );
    } catch (_) {
    } finally {
      _isActionSubmitting = false;
      setBusy(false);
    }
  }
}
