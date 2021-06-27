import 'package:fire_chat/widgets/auth/authCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;
  void _submit(var image, String userName, String email, String password,
      bool authState, BuildContext ctx) async {
    UserCredential authResponse;
    try {
      setState(() {
        _isLoading = true;
      });
      if (authState) {
        authResponse = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResponse = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authResponse.user!.uid + '.jpg');
        await ref.putFile(image).whenComplete(() => null);
        final imageUrl = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResponse.user!.uid)
            .set({
          'userName': userName,
          'userEmail': email,
          'imageUrl': imageUrl
        });
      }
      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (error) {
      setState(() {
        _isLoading = false;
      });
      String errorMessage = 'An error accord, Please try again later';
      if (error.message != null) {
        errorMessage = error.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(ctx).errorColor,
          content: Text(errorMessage),
        ),
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      String errorMessage = error.toString();
      print(error);
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(ctx).errorColor,
          content: Text(errorMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthCard(_submit, _isLoading),
    );
  }
}
