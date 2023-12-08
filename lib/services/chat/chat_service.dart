import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_chat/models/message_model.dart';

class ChatService {
  // MARK: - Instances.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // MARK: - Send Message Method.
  Future<void> sendMessage({
    required String senderUid,
    required String receiverUid,
    required String message,
  }) async {
    // MARK: - Get the current user details.
    final String currentUserEmail = _firebaseAuth.currentUser!.email!;
    final Timestamp currentTime = Timestamp.now();

    // MARK: - Create a new message.
    final Message newMessage = Message(
      senderUid: senderUid,
      senderEmail: currentUserEmail,
      receiverUid: receiverUid,
      message: message,
      timestamp: currentTime,
    );

    // MARK: - Construct chat room id from current user id & receiver id (Sorted to ensure uniqueness).
    List<String> userIds = [senderUid, receiverUid];
    userIds.sort();
    final String chatRoomId = userIds.join('_');

    // MARK: - Add the message to database.
    await _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // MARK: - Get Messages Method.
  Stream<QuerySnapshot> getMessages({
    required String senderUid,
    required String receiverUid,
  }) {
    // MARK: - Construct chat room id from current user ids (Sorted to ensure it matches the id used when sending messages).
    List<String> userIds = [senderUid, receiverUid];
    userIds.sort();
    final String chatRoomId = userIds.join('_');

    // MARK: - Get the messages from database.
    return _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
