import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Alignment alignment;
  final Color backgroundColor;
  final Timestamp timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.alignment,
    required this.backgroundColor,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            ' ${timestamp.toDate().hour}:${timestamp.toDate().minute}',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
