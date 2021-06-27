import 'package:fire_chat/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';

class AuthCard extends StatefulWidget {
  final bool isLoading;
  final Function submit;
  AuthCard(this.submit, this.isLoading);
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final key = GlobalKey<FormState>();
  String _userName = '';
  String _email = '';
  String _password = '';
  var _authState = true;
  var _image;
  void getImage(File pickedImage) {
    _image = pickedImage;
  }

  void _saveForm() {
    if (_image == null && !_authState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text('Please Enter An Image'),
        ),
      );
      return;
    }
    if (!key.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    key.currentState!.save();

    widget.submit(_image, _userName.trim(), _email.trim(), _password.trim(),
        _authState, context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_authState) UserImagePicker(getImage),
                  if (!_authState)
                    TextFormField(
                      key: ValueKey('userName'),
                      textCapitalization: TextCapitalization.words,
                      onSaved: (value) {
                        _userName = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty || value.length < 3) {
                          return 'VALID NAME';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'User Name'),
                    ),
                  TextFormField(
                    key: ValueKey('email'),
                    autocorrect: false,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.none,
                    onSaved: (value) {
                      _email = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'VALID EMAIL ';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Email Address'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    onSaved: (value) {
                      _password = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'VALID Password ';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      onPressed: _saveForm,
                      child: Text(_authState ? 'Login' : 'Sign Up'),
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _authState = !_authState;
                        });
                      },
                      textColor: Theme.of(context).primaryColor,
                      child: Text(_authState
                          ? 'Create New Account'
                          : 'Already have an Account '),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
