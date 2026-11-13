import 'package:blog_rivaan/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Loader extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(strokeWidth: 3,color:AppPallete.whiteColor,),);
  }
}