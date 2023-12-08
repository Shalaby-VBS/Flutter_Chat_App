import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  // MARK: - Properties.
  final String senderUid;
  final String senderEmail;
  final String receiverUid;
  final String message;
  final Timestamp timestamp;

  // MARK: - Constructor.
  Message({
    required this.senderUid,
    required this.senderEmail,
    required this.receiverUid,
    required this.message,
    required this.timestamp,
  });

  // MARK: - Map to Message.
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderUid: map['senderUid'],
      senderEmail: map['senderEmail'],
      receiverUid: map['receiverUid'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }

  // MARK: - Message to Map.
  Map<String, dynamic> toMap() {
    return {
      'senderUid': senderUid,
      'senderEmail': senderEmail,
      'receiverUid': receiverUid,
      'message': message,
      'timestamp': timestamp,
    };
  }
}