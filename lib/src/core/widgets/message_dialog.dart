import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color iconColor;
  final Color buttonColor;
  final String buttonText;
  final VoidCallback onButtonPressed;

  MessageDialog({
    required this.title,
    required this.content,
    required this.icon,
    required this.iconColor,
    required this.buttonColor,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, // Background color
      title: Row(
        children: [
          Icon(icon, color: iconColor),
          SizedBox(width: 10),
          Text(title, style: TextStyle(color: iconColor)),
        ],
      ),
      content: Text(content),
      actions: [
        TextButton(
          child: Text(buttonText, style: TextStyle(color: buttonColor)),
          onPressed: onButtonPressed,
        ),
      ],
    );
  }
}
