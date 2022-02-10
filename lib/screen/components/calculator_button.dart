import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final Function callback;
  final double height;
  final double width;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;

  const CalculatorButton({
    Key? key,
    required this.text,
    required this.callback,
    required this.height,
    required this.width,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      height: height,
      width: width,
      child: TextButton(
        child: Text(
          text,
          textDirection: TextDirection.ltr,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        style: TextButton.styleFrom(
          primary: textColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          backgroundColor: backgroundColor,
        ),
        onPressed: () {
          callback(text);
        },
      ),
    );
  }
}
