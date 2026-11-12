import 'package:blog_rivaan/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  const AuthGradientButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          AppPallete.gradient1,
          AppPallete.gradient2
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight
        ),

        borderRadius: BorderRadius.circular(10)
      ),
      child: ElevatedButton(
        onPressed: () {
          
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPallete.transparentColor,
          shadowColor: AppPallete.transparentColor,
          fixedSize: Size(395, 55),
        ),
      
        child: Text('SignUp',style: Theme.of(context).textTheme.titleMedium,),
      ),
    );
  }
}