import 'package:flutter/material.dart';

class CustomButtonHome extends StatelessWidget {
  final String name;
  final Color color;
  final Function() onPressed;
  const CustomButtonHome( {
    super.key,
    required this.name,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 15,
        ),
        backgroundColor: color,
      ),
      onPressed: onPressed,
      child: Text(
        name,
        style: const TextStyle(
          color:Color.fromARGB(255, 250, 250, 250),
          fontSize: 20,
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
        ),
      ),
    );
  }
}