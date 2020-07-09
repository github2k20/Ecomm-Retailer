import 'package:flutter/material.dart';

class ReusableTextBox extends StatelessWidget {
  ReusableTextBox(@required this.textController,@required this.icon,this.hintText,[this.obscureTextController=false]);

  final TextEditingController textController;
  final String hintText;
  final bool obscureTextController;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      cursorColor: Colors.white,
      obscureText: obscureTextController,
      style: TextStyle(
          color: Colors.white70, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        icon: Icon(icon, color: Colors.white70),
        hintText: hintText,
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white70)),
        hintStyle: TextStyle(
            color: Colors.white70, fontWeight: FontWeight.bold),
      ),

    );
  }
}