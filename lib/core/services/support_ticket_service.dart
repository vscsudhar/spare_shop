import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/services/api_client.dart';
import 'package:spare_shop/core/services/api_endpoints.dart';
import 'package:spare_shop/ui/common/support_ticket_models.dart';

class SupportTicketService {
  final ApiClient _apiClient;

  final ValueNotifier<List<SupportTicketModel>> ticketsNotifier =
      ValueNotifier<List<SupportTicketModel>>([]);

  SupportTicketService({ApiClient? apiClient})
      : _apiClient = apiClient ?? locator<ApiClient>();

  List<SupportTicketModel> get cachedTickets => ticketsNotifier.value;

  /// Get my support tickets with optional status filtering
  Future<List<SupportTicketModel>> getMyTickets({String? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
        queryParams['status'] = status.toLowerCase();
      }

      final response = await _apiClient.get(
        ApiEndpoints.mySupportTickets,
        queryParameters: queryParams,
      );

      final List<dynamic> list = response.data['data'] ?? [];
      final tickets = list
          .map((json) => SupportTicketModel.fromJson(json as Map<String, dynamic>))
          .toList();

      ticketsNotifier.value = tickets;
      return tickets;
    } catch (e) {
      debugPrint('Error getting support tickets: $e');
      return ticketsNotifier.value;
    }
  }

  /// Get single ticket details and chat messages
  Future<Map<String, dynamic>> getTicketDetails(String ticketId) async {
    final response = await _apiClient.get(
      ApiEndpoints.supportTicketById(ticketId),
    );

    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    final ticketJson = data['ticket'] as Map<String, dynamic>? ?? {};
    final messagesList = data['messages'] as List<dynamic>? ?? [];

    final ticket = SupportTicketModel.fromJson(ticketJson);
    final messages = messagesList
        .map((m) => TicketMessageModel.fromJson(m as Map<String, dynamic>))
        .toList();

    return {
      'ticket': ticket,
      'messages': messages,
    };
  }

  /// Create a new support ticket with optional photos
  Future<SupportTicketModel> createTicket({
    required String subject,
    required String category,
    required String description,
    String priority = 'medium',
    List<XFile> photos = const [],
  }) async {
    final formData = FormData.fromMap({
      'subject': subject,
      'category': category,
      'description': description,
      'priority': priority,
    });

    if (photos.isNotEmpty) {
      for (final photo in photos) {
        final bytes = await photo.readAsBytes();
        final multipartFile = MultipartFile.fromBytes(
          bytes,
          filename: photo.name.isNotEmpty ? photo.name : 'photo.jpg',
        );
        formData.files.add(MapEntry('photos', multipartFile));
      }
    }

    final response = await _apiClient.post(
      ApiEndpoints.supportTickets,
      data: formData,
    );

    final ticketData = response.data['data'] as Map<String, dynamic>;
    final createdTicket = SupportTicketModel.fromJson(ticketData);

    // Update local cache
    final updatedList = [createdTicket, ...ticketsNotifier.value];
    ticketsNotifier.value = updatedList;

    return createdTicket;
  }

  /// Send message in ticket chat with optional photo attachment
  Future<TicketMessageModel> sendMessage(
    String ticketId,
    String message, {
    List<XFile> photos = const [],
  }) async {
    final formData = FormData.fromMap({
      'message': message,
    });

    if (photos.isNotEmpty) {
      for (final photo in photos) {
        final bytes = await photo.readAsBytes();
        final multipartFile = MultipartFile.fromBytes(
          bytes,
          filename: photo.name.isNotEmpty ? photo.name : 'attachment.jpg',
        );
        formData.files.add(MapEntry('photos', multipartFile));
      }
    }

    final response = await _apiClient.post(
      ApiEndpoints.supportTicketMessages(ticketId),
      data: formData,
    );

    final msgData = response.data['data'] as Map<String, dynamic>;
    return TicketMessageModel.fromJson(msgData);
  }

  /// Update ticket status (e.g. 'resolved', 'open', 'closed')
  Future<SupportTicketModel> updateStatus(String ticketId, String status) async {
    final response = await _apiClient.patch(
      ApiEndpoints.supportTicketStatus(ticketId),
      data: {'status': status},
    );

    final ticketData = response.data['data'] as Map<String, dynamic>;
    final updatedTicket = SupportTicketModel.fromJson(ticketData);

    // Update cache
    final current = ticketsNotifier.value;
    final index = current.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      final newList = List<SupportTicketModel>.from(current);
      newList[index] = updatedTicket;
      ticketsNotifier.value = newList;
    }

    return updatedTicket;
  }
}
