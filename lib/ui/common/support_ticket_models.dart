import 'package:flutter/material.dart';

enum TicketStatus {
  open,
  pending,
  resolved,
  closed;

  String get displayName {
    switch (this) {
      case TicketStatus.open:
        return 'Open';
      case TicketStatus.pending:
        return 'Pending';
      case TicketStatus.resolved:
        return 'Resolved';
      case TicketStatus.closed:
        return 'Closed';
    }
  }

  Color get color {
    switch (this) {
      case TicketStatus.open:
        return const Color(0xFF0070F3); // Blue
      case TicketStatus.pending:
        return const Color(0xFFFF9800); // Amber/Orange
      case TicketStatus.resolved:
        return const Color(0xFF00B156); // Green
      case TicketStatus.closed:
        return const Color(0xFF757575); // Grey
    }
  }

  Color get backgroundColor {
    switch (this) {
      case TicketStatus.open:
        return const Color(0xFFEBF5FF);
      case TicketStatus.pending:
        return const Color(0xFFFFF4E5);
      case TicketStatus.resolved:
        return const Color(0xFFE8F8F0);
      case TicketStatus.closed:
        return const Color(0xFFF0F0F0);
    }
  }

  static TicketStatus fromString(String? status) {
    if (status == null) return TicketStatus.open;
    switch (status.toLowerCase().trim()) {
      case 'pending':
        return TicketStatus.pending;
      case 'resolved':
        return TicketStatus.resolved;
      case 'closed':
        return TicketStatus.closed;
      case 'open':
      default:
        return TicketStatus.open;
    }
  }
}

class TicketAttachmentModel {
  final String url;
  final DateTime uploadedAt;

  const TicketAttachmentModel({
    required this.url,
    required this.uploadedAt,
  });

  factory TicketAttachmentModel.fromJson(Map<String, dynamic> json) {
    return TicketAttachmentModel(
      url: json['url']?.toString() ?? '',
      uploadedAt: json['uploadedAt'] != null
          ? DateTime.tryParse(json['uploadedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'uploadedAt': uploadedAt.toIso8601String(),
      };
}

class TicketMessageModel {
  final String id;
  final String ticketId;
  final String senderId;
  final String senderName;
  final String? senderImage;
  final String senderRole; // 'customer', 'admin', 'staff'
  final String message;
  final List<TicketAttachmentModel> attachments;
  final bool isRead;
  final DateTime createdAt;

  bool get isCustomer => senderRole == 'customer';
  bool get isAdminOrStaff => senderRole == 'admin' || senderRole == 'staff';

  const TicketMessageModel({
    required this.id,
    required this.ticketId,
    required this.senderId,
    required this.senderName,
    this.senderImage,
    required this.senderRole,
    required this.message,
    this.attachments = const [],
    this.isRead = false,
    required this.createdAt,
  });

  factory TicketMessageModel.fromJson(Map<String, dynamic> json) {
    final senderObj = json['sender'];
    String sId = '';
    String sName = 'User';
    String? sImage;

    if (senderObj is Map<String, dynamic>) {
      sId = (senderObj['_id'] ?? senderObj['id'] ?? '').toString();
      sName = senderObj['name']?.toString() ?? 'Support Staff';
      sImage = senderObj['profileImage']?.toString();
    } else if (senderObj is String) {
      sId = senderObj;
    }

    final rawAttachments = json['attachments'];
    final List<TicketAttachmentModel> attachmentsList = [];
    if (rawAttachments is List) {
      for (final a in rawAttachments) {
        if (a is Map<String, dynamic>) {
          attachmentsList.add(TicketAttachmentModel.fromJson(a));
        } else if (a is String) {
          attachmentsList.add(
            TicketAttachmentModel(url: a, uploadedAt: DateTime.now()),
          );
        }
      }
    }

    return TicketMessageModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      ticketId: (json['ticket'] ?? '').toString(),
      senderId: sId,
      senderName: sName,
      senderImage: sImage,
      senderRole: json['senderRole']?.toString() ?? 'customer',
      message: json['message']?.toString() ?? '',
      attachments: attachmentsList,
      isRead: json['isRead'] == true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class SupportTicketModel {
  final String id;
  final String ticketNumber;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String? customerImage;
  final String subject;
  final String category;
  final String description;
  final TicketStatus status;
  final String priority;
  final List<TicketAttachmentModel> photos;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? resolvedAt;
  final DateTime? closedAt;

  const SupportTicketModel({
    required this.id,
    required this.ticketNumber,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    this.customerImage,
    required this.subject,
    required this.category,
    required this.description,
    required this.status,
    this.priority = 'medium',
    this.photos = const [],
    required this.createdAt,
    required this.updatedAt,
    this.resolvedAt,
    this.closedAt,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    final userObj = json['user'];
    String uId = '';
    String uName = 'Customer';
    String uEmail = '';
    String uPhone = '';
    String? uImage;

    if (userObj is Map<String, dynamic>) {
      uId = (userObj['_id'] ?? userObj['id'] ?? '').toString();
      uName = userObj['name']?.toString() ?? 'Customer';
      uEmail = userObj['email']?.toString() ?? '';
      uPhone = userObj['phone']?.toString() ?? '';
      uImage = userObj['profileImage']?.toString();
    } else if (userObj is String) {
      uId = userObj;
    }

    final rawPhotos = json['photos'];
    final List<TicketAttachmentModel> photoList = [];
    if (rawPhotos is List) {
      for (final p in rawPhotos) {
        if (p is Map<String, dynamic>) {
          photoList.add(TicketAttachmentModel.fromJson(p));
        } else if (p is String) {
          photoList.add(TicketAttachmentModel(url: p, uploadedAt: DateTime.now()));
        }
      }
    }

    return SupportTicketModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      ticketNumber: json['ticketNumber']?.toString() ?? 'TKT-0000',
      customerId: uId,
      customerName: uName,
      customerEmail: uEmail,
      customerPhone: uPhone,
      customerImage: uImage,
      subject: json['subject']?.toString() ?? 'Support Ticket',
      category: json['category']?.toString() ?? 'General',
      description: json['description']?.toString() ?? '',
      status: TicketStatus.fromString(json['status']?.toString()),
      priority: json['priority']?.toString() ?? 'medium',
      photos: photoList,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.tryParse(json['resolvedAt'].toString())
          : null,
      closedAt: json['closedAt'] != null
          ? DateTime.tryParse(json['closedAt'].toString())
          : null,
    );
  }

  SupportTicketModel copyWith({
    String? id,
    String? ticketNumber,
    String? customerId,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? customerImage,
    String? subject,
    String? category,
    String? description,
    TicketStatus? status,
    String? priority,
    List<TicketAttachmentModel>? photos,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
    DateTime? closedAt,
  }) {
    return SupportTicketModel(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      customerImage: customerImage ?? this.customerImage,
      subject: subject ?? this.subject,
      category: category ?? this.category,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      photos: photos ?? this.photos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      closedAt: closedAt ?? this.closedAt,
    );
  }
}
