import 'dart:io';

import 'package:blog_rivaan/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_rivaan/core/common/widgets/loader.dart';
import 'package:blog_rivaan/core/constants/constants.dart';
import 'package:blog_rivaan/core/theme/app_pallete.dart';
import 'package:blog_rivaan/core/utils/pick_image.dart';
import 'package:blog_rivaan/core/utils/show_snackbar.dart';
import 'package:blog_rivaan/features/blog/presentation/bloc/bloc/blog_bloc.dart';
import 'package:blog_rivaan/features/blog/presentation/pages/blog_pages.dart';
import 'package:blog_rivaan/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_box/dotted_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNeewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const AddNeewBlogPage());
  const AddNeewBlogPage({super.key});

  @override
  State<AddNeewBlogPage> createState() => _AddNeewBlogPageState();
}

class _AddNeewBlogPageState extends State<AddNeewBlogPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final List<String> selectedTopic = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? image;

  void selectedImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadBlog() {
    if (image == null) {
      showSnackbar(context, 'Please select a cover image for your story');
      return;
    }
    if (selectedTopic.isEmpty) {
      showSnackbar(context, 'Please select at least one topic');
      return;
    }
    if (formKey.currentState!.validate()) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggeIn).user.id;
      context.read<BlogBloc>().add(
        BlogUpload(
          posterId: posterId,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          image: image!,
          topics: selectedTopic,
        ),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
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
        title: const Text(
          'Write Story',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton.icon(
              onPressed: uploadBlog,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPallete.gradient2,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(Icons.send_rounded, size: 16),
              label: const Text(
                'Publish',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),

      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.error);
          }
          if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const BlogPage()),
              ((route) => false),
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover Image Picker
                  GestureDetector(
                    onTap: selectedImage,
                    child: image != null
                        ? Container(
                            height: 210,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    image!,
                                    height: 210,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.65),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white24,
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.photo_camera_rounded,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'Change Cover',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            height: 190,
                            width: double.infinity,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                DottedBox(
                                  height: 190,
                                  width: double.infinity,
                                  borderShape: Shape.rectangle,
                                  borderRadius: 20,
                                  borderThickness: 2,
                                  borderColor: AppPallete.borderColor,
                                  space: 4,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: AppPallete.cardColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppPallete.borderColor,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.add_photo_alternate_rounded,
                                        size: 32,
                                        color: AppPallete.gradient2,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Add Cover Image',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'PNG, JPG up to 10MB',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppPallete.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                  ),

                  const SizedBox(height: 22),

                  // Topic Tag Selector
                  const Text(
                    'Select Topics',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppPallete.textSecondary,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: Constants.topics.map((topic) {
                        final isSelected = selectedTopic.contains(topic);
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedTopic.remove(topic);
                                } else {
                                  selectedTopic.add(topic);
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? const LinearGradient(
                                        colors: [
                                          AppPallete.gradient1,
                                          AppPallete.gradient2,
                                        ],
                                      )
                                    : null,
                                color: isSelected
                                    ? null
                                    : AppPallete.cardColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppPallete.gradient2
                                      : AppPallete.borderColor,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSelected) ...[
                                    const Icon(
                                      Icons.check_rounded,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  Text(
                                    topic,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppPallete.textSecondary,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Story Title Field
                  BlogEditor(
                    controller: titleController,
                    hintText: 'Title of your story...',
                  ),

                  const SizedBox(height: 16),

                  // Story Content Field
                  BlogEditor(
                    controller: contentController,
                    hintText: 'Tell your story...',
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
