import 'package:blog_rivaan/core/common/widgets/loader.dart';
import 'package:blog_rivaan/core/route/route_name.dart';
import 'package:blog_rivaan/core/theme/app_pallete.dart';
import 'package:blog_rivaan/core/utils/show_snackbar.dart';
import 'package:blog_rivaan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_rivaan/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_rivaan/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackbar(context, state.msg);
            print(state.msg);
          }
          if (state is AuthSuccess) {
            Navigator.pushNamed(context, RouteName.login_page);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: SafeArea(
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    AuthField(
                      hintText: 'User Name',
                      controller: nameController,
                    ),
                    const SizedBox(height: 15),

                    AuthField(hintText: 'Email', controller: emailController),
                    const SizedBox(height: 15),

                    AuthField(
                      hintText: 'Password',
                      controller: passwordController,
                      isObsecureText: true,
                    ),
                    const SizedBox(height: 20),

                    if (state is AuthLoading)
                      Loader()
                    else
                      AuthGradientButton(
                        buttonText: 'Sign Up',
                        onpressed: () {
                          if (formkey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              AuthSignUp(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                name: nameController.text.trim(),
                              ),
                            );
                          }
                        },
                      ),
                    const SizedBox(height: 20),

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
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(
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
          );
        },
      ),
    );
  }
}
