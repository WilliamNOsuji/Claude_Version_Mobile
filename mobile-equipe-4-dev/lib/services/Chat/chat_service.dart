// lib/services/chat_service.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobilelapincouvert/models/chat_message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _chatsCollection = 'chats';
  final String _messagesCollection = 'messages';

  // Create a new chat session when a delivery is assigned
  Future<void> createChat(int commandId, int clientId, int deliveryManId) async {
    final chatRef = _firestore.collection(_chatsCollection).doc(commandId.toString());

    // Check if chat already exists
    //final chatDoc = await chatRef.get();
    //if (chatDoc.exists) {
    //  // If chat exists but is not active, reactivate it
    //  if (!(chatDoc.data()?['isActive'] ?? false)) {
    //    await chatRef.update({
    //      'isActive': true,
    //      'endedAt': null,
    //    });
    //  }
    //  return;
    //}

    // Create new chat
    final chat = Chat(
      commandId: commandId,
      clientId: clientId,
      deliveryManId: deliveryManId,
      isActive: true,
      createdAt: DateTime.now(),
    );

    await chatRef.set(chat.toFirestore());
  }

  // End a chat session when a delivery is completed
  Future<void> endChat(int commandId) async {
    final chatRef = _firestore.collection(_chatsCollection).doc(commandId.toString());

    await chatRef.update({
      'isActive': false,
      'endedAt': FieldValue.serverTimestamp(),
    });
  }

  // Send a text message
  Future<void> sendTextMessage({
    required int commandId,
    required String senderId,
    required SenderType senderType,
    required String text,
  }) async {
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
  }

  // Send an emoji message
  Future<void> sendEmojiMessage({
    required int commandId,
    required String senderId,
    required SenderType senderType,
    required String emoji,
  }) async {
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
  }

  // Send an image message
  Future<void> sendImageMessage({
    required int commandId,
    required String senderId,
    required SenderType senderType,
    required File imageFile,
  }) async {
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
  }

  // Add a reaction to a message
  Future<void> addReaction({
    required int commandId,
    required String messageId,
    required String userId,
    required String reaction,
  }) async {
    final messageRef = _firestore
        .collection(_chatsCollection)
        .doc(commandId.toString())
        .collection(_messagesCollection)
        .doc(messageId);

    await messageRef.update({
      'reactions.$userId': reaction,
    });
  }

  // Remove a reaction from a message
  Future<void> removeReaction({
    required int commandId,
    required String messageId,
    required String userId,
  }) async {
    final messageRef = _firestore
        .collection(_chatsCollection)
        .doc(commandId.toString())
        .collection(_messagesCollection)
        .doc(messageId);

    await messageRef.update({
      'reactions.$userId': FieldValue.delete(),
    });
  }

  // Mark message as read
  Future<void> markAsRead({
    required int commandId,
    required String messageId,
  }) async {
    final messageRef = _firestore
        .collection(_chatsCollection)
        .doc(commandId.toString())
        .collection(_messagesCollection)
        .doc(messageId);

    await messageRef.update({
      'isRead': true,
    });
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
    final chatDoc = await _firestore
        .collection(_chatsCollection)
        .doc(commandId.toString())
        .get();

    if (!chatDoc.exists) {
      return false;
    }

    return chatDoc.data()?['isActive'] ?? false;
  }

  // Get chat metadata (client info, delivery person info, etc.)
  Future<Chat?> getChatMetadata(int commandId) async {
    final chatDoc = await _firestore
        .collection(_chatsCollection)
        .doc(commandId.toString())
        .get();

    if (!chatDoc.exists) {
      return null;
    }

    return Chat.fromFirestore(chatDoc);
  }

  // Get unread messages count
  Future<int> getUnreadMessagesCount({
    required int commandId,
    required String userId,
  }) async {
    final querySnapshot = await _firestore
        .collection(_chatsCollection)
        .doc(commandId.toString())
        .collection(_messagesCollection)
        .where('isRead', isEqualTo: false)
        .where('senderId', isNotEqualTo: userId)
        .get();

    return querySnapshot.docs.length;
  }

  // Pick an image from gallery or camera
  Future<File?> pickImage({required ImageSource source}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile == null) {
      return null;
    }

    return File(pickedFile.path);
  }
}