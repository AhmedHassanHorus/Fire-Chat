import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function getImage;
  UserImagePicker(this.getImage);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  var _image;
  void _pickImage() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('From where?'),
        content: Text('From where do you want to pick the image?'),
        actions: [
          FlatButton.icon(
            onPressed: () async {
              final image = await ImagePicker().getImage(
                  source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
              if (image == null) {
                return;
              }
              setState(() {
                _image = File(image.path);
              });
              widget.getImage(_image);
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.camera,
              color: Theme.of(context).accentColor,
            ),
            textColor: Theme.of(context).accentColor,
            label: Text('camera'),
          ),
          FlatButton.icon(
            onPressed: () async {
              final image = await ImagePicker().getImage(
                  source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
              if (image == null) {
                return;
              }
              setState(() {
                _image = File(image.path);
              });
              widget.getImage(_image);

              Navigator.pop(context);
            },
            icon: Icon(
              Icons.image,
              color: Theme.of(context).accentColor,
            ),
            textColor: Theme.of(context).accentColor,
            label: Text('gallery'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _image == null ? null : FileImage(_image),
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          label: Text('Pick Image'),
          icon: Icon(
            Icons.camera,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
