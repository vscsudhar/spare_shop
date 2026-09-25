import 'package:spare_shop/app/app.locator.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class SuggestionService {
  final ApiClient _apiClient;

  SuggestionService({ApiClient? apiClient})
      : _apiClient = apiClient ?? locator<ApiClient>();

  Future<bool> submitSuggestion({
    String? name,
    String? phone,
    required String suggestion,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.suggestions,
      data: {
        'name': (name != null && name.trim().isNotEmpty) ? name.trim() : 'Customer',
        'phone': (phone != null && phone.trim().isNotEmpty) ? phone.trim() : 'N/A',
        'suggestion': suggestion.trim(),
      },
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
