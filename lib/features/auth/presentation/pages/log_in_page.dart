import 'package:blog_rivaan/core/common/widgets/loader.dart';
import 'package:blog_rivaan/core/route/route_name.dart';
import 'package:blog_rivaan/core/theme/app_pallete.dart';
import 'package:blog_rivaan/core/utils/show_snackbar.dart';
import 'package:blog_rivaan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_rivaan/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_rivaan/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                return showSnackbar(context, state.msg);
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) return Loader();
              return Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    SizedBox(height: 30),
                    Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 15),

                    AuthField(hintText: 'Email', controller: emailController),
                    SizedBox(height: 15),

                    AuthField(
                      hintText: 'Password',
                      controller: passwordController,
                      isObsecureText: true,
                    ),
                    SizedBox(height: 20),
                    AuthGradientButton(
                      buttonText: 'Sign In',
                      onpressed: () {
                        if (formkey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            AuthLogIn(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            ),
                          );

                          debugPrint('loggedin');
                        }
                      },
                    ),
                    SizedBox(height: 20),

                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RouteName.signup_page);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account? ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Sign Up ',
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
              );
            },
          ),
        ),
      ),
    );
  }
}
