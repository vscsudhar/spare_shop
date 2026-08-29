import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/app/app.router.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/rare_request_service.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class RareRequestDetailViewModel extends BaseViewModel with NavigationMixin {
  final _rareRequestService = locator<RareRequestService>();
  late String _requestId;

  RareProductRequestModel? _request;
  RareProductRequestModel? get request => _request;

  void init(String id) async {
    _requestId = id;
    setBusy(true);
    try {
      _request = await _rareRequestService.getRequestById(id);
      rebuildUi();
    } catch (e) {
      print('Error loading request detail: $e');
    } finally {
      setBusy(false);
    }
  }

  Color getStatusColor(RareRequestStatus status) {
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

  String getStatusDescription(RareRequestStatus status) {
    switch (status) {
      case RareRequestStatus.submitted:
        return 'Your request has been sent to the admin team. We are matching compatibility specs.';
      case RareRequestStatus.searching:
        return 'We are contacting regional suppliers and warehouse logistics to find a matching spare part.';
      case RareRequestStatus.found:
        return 'A compatible spare part has been found. We are preparing the official quotation details.';
      case RareRequestStatus.quotationSent:
        return 'Official quotation received. Open chat to view pricing breakdown and approve/cancel.';
      case RareRequestStatus.negotiation:
        return 'Negotiations or request revision is ongoing with the support representative.';
      case RareRequestStatus.approved:
        return 'You approved the pricing quotation. Admin will convert it to a regular order shortly.';
      case RareRequestStatus.cancelled:
        return 'The request was cancelled.';
      case RareRequestStatus.convertedToOrder:
        return 'The request has been successfully converted to regular checkout order.';
    }
  }

  void goToChat(String id) {
    navigationService.navigateTo(
      Routes.requestChatQuotationView,
      arguments: RequestChatQuotationViewArguments(requestId: id),
    );
  }
}
