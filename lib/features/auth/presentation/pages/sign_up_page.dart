import 'package:blog_rivaan/core/theme/app_pallete.dart';
import 'package:blog_rivaan/core/utils/show_snackbar.dart';
import 'package:blog_rivaan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_rivaan/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_rivaan/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:blog_rivaan/features/blog/presentation/pages/blog_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const SignUpPage());
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void _onSignUp() {
    if (formkey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthSignUp(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          name: nameController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppPallete.cardColor,
                shape: BoxShape.circle,
                border: Border.all(color: AppPallete.borderColor),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackbar(context, state.msg);
            }
            if (state is AuthSuccess) {
              showSnackbar(context, 'Account created successfully!');
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo Badge
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
                          Icons.edit_note_rounded,
                          size: 38,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Headline
                      const Text(
                        'Create Account',
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
                        'Join our community of passionate writers, thinkers, and lifelong learners.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppPallete.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Full Name
                      AuthField(
                        hintText: 'Full Name',
                        controller: nameController,
                        prefixIcon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 16),

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
                        buttonText: 'Get Started',
                        isLoading: state is AuthLoading,
                        onpressed: _onSignUp,
                      ),
                      const SizedBox(height: 32),

                      // Navigation to Sign In
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: const TextStyle(
                              color: AppPallete.textSecondary,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign In',
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
