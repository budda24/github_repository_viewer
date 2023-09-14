import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final String hint;
  final TextEditingController _controller;

  const CustomSearchBar(
    this._controller, {
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[800]),
        hintText: hint,
        fillColor: Colors.white70,
      ),
    );
  }
}
