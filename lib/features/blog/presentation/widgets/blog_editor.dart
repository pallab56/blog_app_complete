import 'package:blog_rivaan/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const BlogEditor({super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$hintText is required';
        }
        return null;
      },
      controller: controller,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppPallete.textSecondary,
          fontSize: 15,
        ),
        filled: true,
        fillColor: AppPallete.cardColor,
        contentPadding: const EdgeInsets.all(18),
      ),
      maxLines: null,
    );
  }
}
