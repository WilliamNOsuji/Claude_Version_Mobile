// lib/services/Chat/chat_service.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobilelapincouvert/models/chat_message.dart';
import 'package:mobilelapincouvert/services/api_service.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _chatsCollection = 'chats';
  final String _messagesCollection = 'messages';

  // Create a new chat session when a delivery is assigned
  Future<void> createChat(int commandId, int clientId, int deliveryManId) async {
    try {
      final chatRef = _firestore.collection(_chatsCollection).doc(commandId.toString());

      // Check if chat already exists
      final chatDoc = await chatRef.get();
      if (chatDoc.exists) {
        // If chat exists but is not active, reactivate it
        if (!(chatDoc.data()?['isActive'] ?? false)) {
          await chatRef.update({
            'isActive': true,
            'endedAt': null,
          });
        }
        return;
      }

      // Create new chat
      final chat = Chat(
        commandId: commandId,
        clientId: clientId,
        deliveryManId: deliveryManId,
        isActive: true,
        createdAt: DateTime.now(),
      );

      await chatRef.set(chat.toFirestore());

      // Add a system message indicating chat has started
      await sendSystemMessage(
        commandId: commandId,
        text: "Chat started for order #$commandId",
      );

    } catch (e) {
      print('Error creating chat: $e');
      // Better error handling here
    }
  }

  // Send a system message
  Future<void> sendSystemMessage({
    required int commandId,
    required String text,
  }) async {
    try {
      final messageRef = _firestore
          .collection(_chatsCollection)
          .doc(commandId.toString())
          .collection(_messagesCollection)
          .doc();

      final message = ChatMessage(
        id: messageRef.id,
        content: text,
        timestamp: DateTime.now(),
        senderId: "system",
        senderType: SenderType.client, // Doesn't matter for system messages
        messageType: MessageType.text,
        isRead: true,
      );

      await messageRef.set(message.toFirestore());
    } catch (e) {
      print('Error sending system message: $e');
    }
  }

  // End a chat session when a delivery is completed
  Future<void> endChat(int commandId) async {
    try {
      final chatRef = _firestore.collection(_chatsCollection).doc(commandId.toString());

      // Add a system message saying the chat has ended
      await sendSystemMessage(
        commandId: commandId,
        text: "Delivery completed. Chat ended.",
      );

      await chatRef.update({
        'isActive': false,
        'endedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error ending chat: $e');
    }
  }

  // Send a text message
  Future<void> sendTextMessage({
    required int commandId,
    required String senderId,
    required SenderType senderType,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    try {
      final messageRef = _firestore
          .collection(_chatsCollection)
          .doc(commandId.toString())
          .collection(_messagesCollection)
          .doc();

      final message = ChatMessage(
        id: messageRef.id,
        content: text,
        timestamp: DateTime.now(),
        senderId: senderId,
        senderType: senderType,
        messageType: MessageType.text,
      );

      await messageRef.set(message.toFirestore());
    } catch (e) {
      print('Error sending text message: $e');
    }
  }

  // Send an emoji message
  Future<void> sendEmojiMessage({
    required int commandId,
    required String senderId,
    required SenderType senderType,
    required String emoji,
  }) async {
    try {
      final messageRef = _firestore
          .collection(_chatsCollection)
          .doc(commandId.toString())
          .collection(_messagesCollection)
          .doc();

      final message = ChatMessage(
        id: messageRef.id,
        content: emoji,
        timestamp: DateTime.now(),
        senderId: senderId,
        senderType: senderType,
        messageType: MessageType.emoji,
      );

      await messageRef.set(message.toFirestore());
    } catch (e) {
      print('Error sending emoji: $e');
    }
  }

  // Send an image message
  Future<void> sendImageMessage({
    required int commandId,
    required String senderId,
    required SenderType senderType,
    required File imageFile,
  }) async {
    try {
      // First upload the image to Firebase Storage
      final storageRef = _storage
          .ref()
          .child('chat_images')
          .child(commandId.toString())
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Then create the message with the image URL
      final messageRef = _firestore
          .collection(_chatsCollection)
          .doc(commandId.toString())
          .collection(_messagesCollection)
          .doc();

      final message = ChatMessage(
        id: messageRef.id,
        content: downloadUrl,
        timestamp: DateTime.now(),
        senderId: senderId,
        senderType: senderType,
        messageType: MessageType.image,
      );

      await messageRef.set(message.toFirestore());
    } catch (e) {
      print('Error sending image: $e');
    }
  }

  // Add a reaction to a message
  Future<void> addReaction({
    required int commandId,
    required String messageId,
    required String userId,
    required String reaction,
  }) async {
    try {
      final messageRef = _firestore
          .collection(_chatsCollection)
          .doc(commandId.toString())
          .collection(_messagesCollection)
          .doc(messageId);

      await messageRef.update({
        'reactions.$userId': reaction,
      });
    } catch (e) {
      print('Error adding reaction: $e');
    }
  }

  // Remove a reaction from a message
  Future<void> removeReaction({
    required int commandId,
    required String messageId,
    required String userId,
  }) async {
    try {
      final messageRef = _firestore
          .collection(_chatsCollection)
          .doc(commandId.toString())
          .collection(_messagesCollection)
          .doc(messageId);

      await messageRef.update({
        'reactions.$userId': FieldValue.delete(),
      });
    } catch (e) {
      print('Error removing reaction: $e');
    }
  }

  // Mark message as read
  Future<void> markAsRead({
    required int commandId,
    required String messageId,
  }) async {
    try {
      final messageRef = _firestore
          .collection(_chatsCollection)
          .doc(commandId.toString())
          .collection(_messagesCollection)
          .doc(messageId);

      await messageRef.update({
        'isRead': true,
      });
    } catch (e) {
      print('Error marking message as read: $e');
    }
  }

  // Get messages stream for a specific chat
  Stream<List<ChatMessage>> getMessagesStream(int commandId) {
    return _firestore
        .collection(_chatsCollection)
        .doc(commandId.toString())
        .collection(_messagesCollection)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc))
          .toList();
    });
  }

  // Check if a chat exists and is active
  Future<bool> isChatActive(int commandId) async {
    try {
      final chatDoc = await _firestore
          .collection(_chatsCollection)
          .doc(commandId.toString())
          .get();

      if (!chatDoc.exists) {
        return false;
      }

      return chatDoc.data()?['isActive'] ?? false;
    } catch (e) {
      print('Error checking if chat is active: $e');
      return false;
    }
  }

  // Get chat metadata (client info, delivery person info, etc.)
  Future<Chat?> getChatMetadata(int commandId) async {
    try {
      final chatDoc = await _firestore
          .collection(_chatsCollection)
          .doc(commandId.toString())
          .get();

      if (!chatDoc.exists) {
        return null;
      }

      return Chat.fromFirestore(chatDoc);
    } catch (e) {
      print('Error getting chat metadata: $e');
      return null;
    }
  }

  // Get unread messages count
  Future<int> getUnreadMessagesCount({
    required int commandId,
    required String userId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(_chatsCollection)
          .doc(commandId.toString())
          .collection(_messagesCollection)
          .where('isRead', isEqualTo: false)
          .where('senderId', isNotEqualTo: userId)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      print('Error getting unread message count: $e');
      return 0;
    }
  }

  // Pick an image from gallery or camera
  Future<File?> pickImage({required ImageSource source}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (pickedFile == null) {
        return null;
      }

      return File(pickedFile.path);
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // Get all active chats for a user (either as client or delivery person)
  Stream<List<Chat>> getUserActiveChatsStream(int userId) {
    return _firestore
        .collection(_chatsCollection)
        .where('isActive', isEqualTo: true)
        .where(Filter.or(
      Filter('clientId', isEqualTo: userId),
      Filter('deliveryManId', isEqualTo: userId),
    ))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Chat.fromFirestore(doc))
          .toList();
    });
  }

  // Initialize a chat when delivery is marked as in progress
  Future<void> initializeChat(int commandId, int clientId, int deliveryManId) async {
    bool chatExists = await isChatActive(commandId);

    if (!chatExists) {
      await createChat(commandId, clientId, deliveryManId);
    }
  }
}