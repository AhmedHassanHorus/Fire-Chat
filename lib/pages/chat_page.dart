import 'package:fire_chat/widgets/chat/message_field.dart';
import 'package:fire_chat/widgets/chat/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FireChat'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Are you sure?'),
                    content: Text('Do you want to exit'),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          FirebaseAuth.instance.signOut();
                        },
                        child: Text('yes'),
                        textColor: Theme.of(context).accentColor,
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('no'),
                        textColor: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Messages(),
              ),
              MessageField(),
            ],
          ),
        ));
  }
}
