import 'package:blog_rivaan/core/route/route_name.dart';
import 'package:blog_rivaan/core/theme/app_pallete.dart';
import 'package:blog_rivaan/core/utils/show_snackbar.dart';
import 'package:blog_rivaan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_rivaan/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_rivaan/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:blog_rivaan/features/blog/presentation/pages/blog_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogInPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const LogInPage());
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() {
    if (formkey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLogIn(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackbar(context, state.msg);
            }
            if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const BlogPage()),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // App Brand Icon
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppPallete.gradient1, AppPallete.gradient2],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: AppPallete.gradient2.withValues(alpha: 0.35),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.auto_stories_rounded,
                          size: 38,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Welcome Headline
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Editorial Subtitle
                      const Text(
                        'Sign in to explore stories, read articles, and share your perspective.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppPallete.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Email Field
                      AuthField(
                        hintText: 'Email Address',
                        controller: emailController,
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      AuthField(
                        hintText: 'Password',
                        controller: passwordController,
                        prefixIcon: Icons.lock_outline_rounded,
                        isObsecureText: true,
                      ),
                      const SizedBox(height: 28),

                      // Submit Gradient Button
                      AuthGradientButton(
                        buttonText: 'Sign In',
                        isLoading: state is AuthLoading,
                        onpressed: _onSignIn,
                      ),
                      const SizedBox(height: 32),

                      // Navigation to Sign Up
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RouteName.signup_page);
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: const TextStyle(
                              color: AppPallete.textSecondary,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: AppPallete.gradient2,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppPallete.gradient2.withValues(alpha: 0.5),
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
      ),
    );
  }
}
