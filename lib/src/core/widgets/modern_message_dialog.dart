import 'package:flutter/material.dart';

class ModernMessageDialog extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color iconColor;
  final Color okButtonColor;
  final Color cancelButtonColor;
  final String okButtonText;
  final String cancelButtonText;
  final VoidCallback onOkButtonPressed;
  final VoidCallback onCancelButtonPressed;

  ModernMessageDialog({
    required this.title,
    required this.content,
    required this.icon,
    required this.iconColor,
    required this.okButtonColor,
    required this.cancelButtonColor,
    required this.okButtonText,
    required this.cancelButtonText,
    required this.onOkButtonPressed,
    required this.onCancelButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent, // Use a transparent background
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: iconColor,
                    size: 36.0, // Adjust the icon size as needed
                  ),
                  SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(
                      color: iconColor,
                      fontSize: 18.0, // Adjust the font size as needed
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Divider(), // Add a divider for a modern look
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(content),
            ),
            Divider(), // Add another divider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: onOkButtonPressed,
                  child: Text(
                    okButtonText,
                    style: TextStyle(
                      color: okButtonColor,
                      fontSize: 16.0, // Adjust the font size as needed
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onCancelButtonPressed,
                  child: Text(
                    cancelButtonText,
                    style: TextStyle(
                      color: cancelButtonColor,
                      fontSize: 16.0, // Adjust the font size as needed
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
