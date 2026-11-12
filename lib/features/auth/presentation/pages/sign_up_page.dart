import 'package:blog_rivaan/core/route/route_name.dart';
import 'package:blog_rivaan/core/theme/app_pallete.dart';
import 'package:blog_rivaan/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_rivaan/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final GlobalKey formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SafeArea(
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
            
              children: [
                SizedBox(height: 30),
                Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            
                SizedBox(height: 15),
            
                AuthField(hintText: 'User Name',controller: nameController,),
                SizedBox(height: 15),
            
                AuthField(hintText: 'Email',controller: emailController,),
                SizedBox(height: 15),
            
                AuthField(hintText: 'Password',controller: passwordController,isObsecureText: true,),
                SizedBox(height: 20),
                AuthGradientButton(),
                SizedBox(height: 20),
            
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.login_page);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Allready have an account? ',
                      style: Theme.of(context).textTheme.titleMedium,
                      children: [
                        TextSpan(
                          text: 'Sign In ',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppPallete.gradient2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
