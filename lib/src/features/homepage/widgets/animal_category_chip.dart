import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimalCategoryChip extends StatelessWidget {
  final String name;
  final String emoji;
  final Color backgroundColor;
  final Color textColor;

  const AnimalCategoryChip({
    required this.name,
    required this.emoji,
    this.backgroundColor = Colors.orange,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 12.0,
              backgroundColor: Colors.transparent,
              child: Text(
                emoji,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(width: 8.0),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
