import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat/services/chat/chat_service.dart';

import '../components/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUid;
  final String receiverEmail;
  const ChatScreen({
    super.key,
    required this.receiverUid,
    required this.receiverEmail,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService chatService = ChatService();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(
        senderUid: firebaseAuth.currentUser!.uid,
        receiverUid: widget.receiverUid,
        message: messageController.text,
      );
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail,
            style: const TextStyle(fontSize: 16, color: Colors.white)),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: chatService.getMessages(
                  senderUid: firebaseAuth.currentUser!.uid,
                  receiverUid: widget.receiverUid,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: Text('Loading...'),
                    );
                  } else {
                    // final messages = snapshot.data!.docs;
                    return ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      children: snapshot.data!.docs
                          .map((document) => _buildMessageItem(document))
                          .toList(),
                    );
                  }
                },
              ),
            ),
            _buildTypeMessageBar(messageController, sendMessage),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    var alignment = (data['senderUid'] == firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Row(
      mainAxisAlignment: (data['senderUid'] == firebaseAuth.currentUser!.uid)
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        (data['senderUid'] == firebaseAuth.currentUser!.uid)
            ? const Spacer()
            : const SizedBox.shrink(),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: alignment,
            decoration: BoxDecoration(
              color: document['senderUid'] == firebaseAuth.currentUser!.uid
                  ? Colors.lightBlue
                  : Colors.deepPurple,
              borderRadius: BorderRadius.circular(18),
            ),
            child: ChatBubble(
              alignment: alignment,
              backgroundColor:
                  document['senderUid'] == firebaseAuth.currentUser!.uid
                      ? Colors.lightBlue
                      : Colors.deepPurple,
              message: document['message'],
              timestamp: document['timestamp'],
            ),
          ),
        ),
        (data['senderUid'] == firebaseAuth.currentUser!.uid)
            ? const SizedBox.shrink()
            : const Spacer(),
      ],
    );
  }

  Widget _buildTypeMessageBar(
    messageController,
    sendMessage,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 5, left: 10),
      child: Row(
        children: [
          Expanded(child: _buildMessageTextField(messageController)),
          ElevatedButton(
            onPressed: sendMessage,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
              backgroundColor: Colors.blue,
            ),
            child: const Icon(Icons.send_rounded, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _buildMessageTextField(messageController) {
    return TextField(
      controller: messageController,
      maxLines: null,
      textAlignVertical: TextAlignVertical.center,
      cursorRadius: const Radius.circular(36),
      cursorColor: Colors.blue,
      cursorHeight: 24,
      decoration: InputDecoration(
        hintText: 'Type a message',
        hintStyle: TextStyle(color: Colors.grey[400], height: 1.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(36),
        ),
      ),
    );
  }
}
