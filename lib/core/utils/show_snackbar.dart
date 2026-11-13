import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void showSnackbar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));
}
