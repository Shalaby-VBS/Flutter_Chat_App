import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_service.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void signOut() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logging out...'),
                  duration: Duration(seconds: 1),
                ),
              );
              signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong!'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }
        return ListView(
          physics: const BouncingScrollPhysics(),
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // MARK: - Display all users except the current user.
    if (firebaseAuth.currentUser!.email != data['email']) {
      return ListTile(
        onTap: () {
          // MARK: - Navigate to the chat screen.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receiverUid: data['uid'],
                receiverEmail: data['email'],
              ),
            ),
          );
        },
        leading: const Icon(Icons.person),
        title:
            Text(data['email'], style: Theme.of(context).textTheme.titleSmall),
        subtitle:
            Text(data['uid'], style: Theme.of(context).textTheme.titleMedium),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
