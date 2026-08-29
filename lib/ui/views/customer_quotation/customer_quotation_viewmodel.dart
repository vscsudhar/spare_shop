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

  late String _requestId;
  late String _quotationId;

  String get requestId => _requestId;
  String get quotationId => _quotationId;

  RareProductRequestModel? _request;
  RareProductRequestModel? get request => _request;

  RareQuotationModel? get quotation => _request?.quotation;

  void init(String reqId, String qId) async {
    _requestId = reqId;
    _quotationId = qId;

    setBusy(true);
    try {
      _request = await _rareRequestService.getRequestById(reqId);
      rebuildUi();
    } catch (_) {
    } finally {
      setBusy(false);
    }
  }

  Future<void> approve() async {
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

      setBusy(false);
      navigationService.navigateTo(
        Routes.quotationApprovedView,
        arguments: QuotationApprovedViewArguments(requestId: _requestId),
      );
    } catch (_) {
      setBusy(false);
    }
  }

  Future<void> cancel(String reason) async {
    setBusy(true);
    try {
      await _rareRequestService.customerDeclineQuotation(
          _requestId, _quotationId, reason);

      setBusy(false);
      navigationService.navigateTo(
        Routes.requestCancelledView,
        arguments: RequestCancelledViewArguments(requestId: _requestId),
      );
    } catch (_) {
      setBusy(false);
    }
  }
}
