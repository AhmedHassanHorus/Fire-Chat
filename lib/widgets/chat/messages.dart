import 'package:fire_chat/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemBuilder: (ctx, ind) => MessageBubble(
            docs[ind]['text'],
            docs[ind]['userName'],
            docs[ind]['imageUrl'],
            docs[ind]['userId'] == FirebaseAuth.instance.currentUser!.uid,
            key: ValueKey(docs[ind].id),
          ),
          itemCount: docs.length,
        );
      },
    );
  }
}
