import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key, required this.text, this.fontSize = 32, this.weight = FontWeight.w400, this.alignment = TextAlign.center, this.color});
  final FontWeight weight;
  final String text;
  final double fontSize;
  final TextAlign alignment;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize, fontWeight: weight,color: color ?? Theme.of(context).textTheme.titleSmall?.color),
      textAlign: alignment,
    );
  }
}

class ArrowBackIcon extends StatelessWidget {
  const ArrowBackIcon({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 45.62,
        ),
        GestureDetector(
          onTap: onPressed,
          child: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }
}

