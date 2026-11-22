import 'package:blog_rivaan/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_rivaan/core/common/entity/user.dart';
import 'package:blog_rivaan/core/common/widgets/loader.dart';
import 'package:blog_rivaan/core/theme/app_pallete.dart';
import 'package:blog_rivaan/core/utils/pick_image.dart';
import 'package:blog_rivaan/core/utils/show_snackbar.dart';
import 'package:blog_rivaan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_rivaan/features/auth/presentation/pages/log_in_page.dart';
import 'package:blog_rivaan/features/blog/presentation/bloc/bloc/blog_bloc.dart';
import 'package:blog_rivaan/features/blog/presentation/pages/add_neew_blog_page.dart';
import 'package:blog_rivaan/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  static const List<Color> _cardPallete = [
    AppPallete.gradient1,
    AppPallete.gradient2,
    AppPallete.gradient3,
    AppPallete.gradient4,
  ];

  @override
  void initState() {
    super.initState();
    _fetchBlogs();
  }

  void _fetchBlogs() {
    context.read<BlogBloc>().add(BLogFetchAllBlogs());
  }

  void _onUploadProfilePicture(BuildContext context, String userId) async {
    final pickedImage = await pickImage();
    if (pickedImage != null && context.mounted) {
      showSnackbar(context, 'Uploading profile picture...');
      context.read<AuthBloc>().add(
        AuthUploadProfileImage(
          image: pickedImage,
          userId: userId,
        ),
      );
    }
  }

  void _confirmLogOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppPallete.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppPallete.borderColor),
          ),
          title: const Row(
            children: [
              Icon(Icons.logout_rounded, color: AppPallete.errorColor, size: 24),
              SizedBox(width: 10),
              Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to log out of your account?',
            style: TextStyle(
              fontSize: 14,
              color: AppPallete.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPallete.errorColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext); // Close dialog
                Navigator.pop(context); // Close bottom sheet
                context.read<AuthBloc>().add(AuthLogOut());
                Navigator.pushAndRemoveUntil(
                  context,
                  LogInPage.route(),
                  (route) => false,
                );
                showSnackbar(context, 'Logged out successfully');
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  void _showProfileModal(BuildContext parentContext, User user) {
    showModalBottomSheet(
      context: parentContext,
      backgroundColor: AppPallete.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (bottomSheetContext) {
        return BlocBuilder<AppUserCubit, AppUserState>(
          builder: (context, state) {
            final currentUser = (state is AppUserLoggeIn) ? state.user : user;
            final initials = currentUser.name.trim().isNotEmpty
                ? currentUser.name.trim()[0].toUpperCase()
                : 'U';
            final hasImage = currentUser.profileImage != null &&
                currentUser.profileImage!.trim().isNotEmpty;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag Handle
                    Container(
                      width: 44,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: AppPallete.borderColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    // Title
                    const Text(
                      'Account Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Profile Picture with Camera Icon Overlay
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppPallete.gradient2,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppPallete.gradient2.withValues(alpha: 0.25),
                                  blurRadius: 18,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 46,
                              backgroundColor: AppPallete.gradient1,
                              backgroundImage:
                                  hasImage ? NetworkImage(currentUser.profileImage!) : null,
                              child: !hasImage
                                  ? Text(
                                      initials,
                                      style: const TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                _onUploadProfilePicture(
                                  parentContext,
                                  currentUser.id,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppPallete.gradient1,
                                      AppPallete.gradient2,
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppPallete.backgroundColor,
                                    width: 2.5,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () {
                        _onUploadProfilePicture(
                          parentContext,
                          currentUser.id,
                        );
                      },
                      icon: const Icon(
                        Icons.photo_library_outlined,
                        size: 16,
                        color: AppPallete.gradient2,
                      ),
                      label: const Text(
                        'Upload New Photo',
                        style: TextStyle(
                          color: AppPallete.gradient2,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // User Details Container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppPallete.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppPallete.borderColor),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline_rounded,
                                color: AppPallete.gradient2,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  currentUser.name.isNotEmpty
                                      ? currentUser.name
                                      : 'No Name Set',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: AppPallete.borderColor,
                            height: 24,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.mail_outline_rounded,
                                color: AppPallete.gradient1,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  currentUser.email.isNotEmpty
                                      ? currentUser.email
                                      : 'No Email Set',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppPallete.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Log Out Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPallete.errorColor.withValues(alpha: 0.15),
                          foregroundColor: AppPallete.errorColor,
                          elevation: 0,
                          side: const BorderSide(
                            color: AppPallete.errorColor,
                            width: 1.2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => _confirmLogOut(parentContext),
                        icon: const Icon(Icons.logout_rounded, size: 20),
                        label: const Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BlogBloc, BlogState>(
          listener: (context, state) {
            if (state is BlogFailure) {
              showSnackbar(context, state.error);
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackbar(context, state.msg);
            }
            if (state is AuthSuccess) {
              showSnackbar(context, 'Profile updated successfully!');
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppPallete.gradient1, AppPallete.gradient2],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Blog Space',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, AddNeewBlogPage.route());
              },
              tooltip: 'Write Blog',
              icon: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppPallete.borderColor.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: AppPallete.whiteColor,
                  size: 20,
                ),
              ),
            ),
            // Profile in AppBar
            BlocBuilder<AppUserCubit, AppUserState>(
              builder: (context, state) {
                if (state is AppUserLoggeIn) {
                  final user = state.user;
                  final initials = user.name.trim().isNotEmpty
                      ? user.name.trim()[0].toUpperCase()
                      : 'U';
                  final hasImage = user.profileImage != null &&
                      user.profileImage!.trim().isNotEmpty;

                  return GestureDetector(
                    onTap: () => _showProfileModal(context, user),
                    child: Container(
                      margin: const EdgeInsets.only(left: 4, right: 12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppPallete.gradient2,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppPallete.gradient1,
                        backgroundImage:
                            hasImage ? NetworkImage(user.profileImage!) : null,
                        child: !hasImage
                            ? Text(
                                initials,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),

        body: BlocBuilder<BlogBloc, BlogState>(
          builder: (context, state) {
            if (state is BlogLoading) {
              return const Loader();
            }

            if (state is BlogDisplaySuccess) {
              if (state.blog.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppPallete.cardColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppPallete.borderColor),
                          ),
                          child: const Icon(
                            Icons.article_outlined,
                            size: 48,
                            color: AppPallete.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'No Stories Yet',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppPallete.whiteColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Be the first to share an inspiring thought or story!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppPallete.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(context, AddNeewBlogPage.route());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPallete.gradient2,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.edit_note_rounded, size: 20),
                          label: const Text(
                            'Write First Story',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  _fetchBlogs();
                },
                color: AppPallete.gradient2,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.blog.length,
                  itemBuilder: (context, index) {
                    final blog = state.blog[index];
                    final cardColor = _cardPallete[index % _cardPallete.length];
                    return BlogCard(blog: blog, color: cardColor);
                  },
                ),
              );
            }

            return const Center(
              child: Text(
                'Nothing to show',
                style: TextStyle(color: AppPallete.textSecondary),
              ),
            );
          },
        ),
      ),
    );
  }
}
