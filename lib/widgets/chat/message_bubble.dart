import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String userName;
  final String imageUrl;
  final Key key;
  final bool isMe;
  MessageBubble(this.text, this.userName, this.imageUrl, this.isMe,
      {required this.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 200),
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isMe
                            ? Colors.black
                            : Theme.of(context)
                                .accentTextTheme
                                .headline1!
                                .color),
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        color: isMe
                            ? Colors.black
                            : Theme.of(context)
                                .accentTextTheme
                                .headline1!
                                .color),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -10,
              // left: isMe ? null : 180,
              // right: !isMe ? null : 180,
              child: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
          ],
          clipBehavior: Clip.none,
          alignment: isMe ? Alignment.topLeft : Alignment.topRight,
        ),
      ],
    );
  }
}
