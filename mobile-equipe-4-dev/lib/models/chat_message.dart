
import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image, emoji }
enum SenderType { client, deliveryMan }

class ChatMessage {
  final String id;
  final String content;
  final DateTime timestamp;
  final String senderId;
  final SenderType senderType;
  final MessageType messageType;
  final Map<String, String> reactions;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.senderId,
    required this.senderType,
    required this.messageType,
    this.reactions = const {},
    this.isRead = false,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      content: data['content'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      senderId: data['senderId'] ?? '',
      senderType: SenderType.values.firstWhere(
              (e) => e.toString() == 'SenderType.${data['senderType']}',
          orElse: () => SenderType.client),
      messageType: MessageType.values.firstWhere(
              (e) => e.toString() == 'MessageType.${data['messageType']}',
          orElse: () => MessageType.text),
      reactions: Map<String, String>.from(data['reactions'] ?? {}),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'senderId': senderId,
      'senderType': senderType.toString().split('.').last,
      'messageType': messageType.toString().split('.').last,
      'reactions': reactions,
      'isRead': isRead,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? content,
    DateTime? timestamp,
    String? senderId,
    SenderType? senderType,
    MessageType? messageType,
    Map<String, String>? reactions,
    bool? isRead,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      senderId: senderId ?? this.senderId,
      senderType: senderType ?? this.senderType,
      messageType: messageType ?? this.messageType,
      reactions: reactions ?? this.reactions,
      isRead: isRead ?? this.isRead,
    );
  }
}

// lib/models/chat.dart
class Chat {
  final int commandId;
  final int clientId;
  final int deliveryManId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? endedAt;

  Chat({
    required this.commandId,
    required this.clientId,
    required this.deliveryManId,
    required this.isActive,
    required this.createdAt,
    this.endedAt,
  });

  factory Chat.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Chat(
      commandId: data['commandId'] ?? 0,
      clientId: data['clientId'] ?? 0,
      deliveryManId: data['deliveryManId'] ?? 0,
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      endedAt: data['endedAt'] != null
          ? (data['endedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'commandId': commandId,
      'clientId': clientId,
      'deliveryManId': deliveryManId,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'endedAt': endedAt != null ? Timestamp.fromDate(endedAt!) : null,
    };
  }

  Chat copyWith({
    int? commandId,
    int? clientId,
    int? deliveryManId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? endedAt,
  }) {
    return Chat(
      commandId: commandId ?? this.commandId,
      clientId: clientId ?? this.clientId,
      deliveryManId: deliveryManId ?? this.deliveryManId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      endedAt: endedAt ?? this.endedAt,
    );
  }
}