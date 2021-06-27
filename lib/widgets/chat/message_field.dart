import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageField extends StatefulWidget {
  @override
  _MessageFieldState createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  final _inputController = TextEditingController();
  String _inputText = '';
  void _send() async {
    try {
      FocusScope.of(context).unfocus();
      _inputController.clear();
      final user = FirebaseAuth.instance.currentUser;
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      await FirebaseFirestore.instance.collection('chat').add({
        'text': _inputText.trim(),
        'time': Timestamp.now(),
        'userId': user.uid,
        'imageUrl': userData['imageUrl'],
        'userName': userData['userName'],
      });
    } catch (error) {
      print('oh error $error');
    }
    setState(() {
      _inputText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autocorrect: true,
              enableSuggestions: true,
              minLines: 1,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'Write some thing...',
              ),
              controller: _inputController,
              onChanged: (value) {
                setState(() {
                  _inputText = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: _inputText.trim().isEmpty ? null : _send,
            icon: Icon(
              Icons.send,
            ),
          ),
        ],
      ),
    );
  }
}
