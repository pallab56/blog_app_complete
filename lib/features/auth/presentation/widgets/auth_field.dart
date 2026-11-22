import 'package:blog_rivaan/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AuthField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObsecureText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObsecureText = false,
    this.prefixIcon,
    this.keyboardType,
    this.validator,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isObsecureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      keyboardType: widget.keyboardType,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
      validator: widget.validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return "${widget.hintText} is required";
            }
            if (widget.hintText.toLowerCase().contains('email') &&
                !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
              return "Please enter a valid email address";
            }
            if (widget.hintText.toLowerCase().contains('password') &&
                value.trim().length < 6) {
              return "Password must be at least 6 characters";
            }
            return null;
          },
      decoration: InputDecoration(
        filled: true,
        fillColor: AppPallete.cardColor,
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: AppPallete.textSecondary,
          fontSize: 14,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: AppPallete.textSecondary,
                size: 20,
              )
            : null,
        suffixIcon: widget.isObsecureText
            ? IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppPallete.textSecondary,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppPallete.borderColor,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppPallete.gradient2,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppPallete.errorColor,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppPallete.errorColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
