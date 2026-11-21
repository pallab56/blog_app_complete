import 'dart:io';

import 'package:blog_rivaan/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_rivaan/core/common/widgets/loader.dart';
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
  static route() => MaterialPageRoute(builder: (_) => AddNeewBlogPage());
  const AddNeewBlogPage({super.key});

  @override
  State<AddNeewBlogPage> createState() => _AddNeewBlogPageState();
}

class _AddNeewBlogPageState extends State<AddNeewBlogPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final List<String> selectedTopic = [];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? image;
  void selectedImage() async {
    final pickedImage = await pickImage();
    print(pickedImage);
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    } else {
      print('path not recognised');
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopic.isNotEmpty &&
        image != null) {
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
        actions: [
          IconButton(onPressed: uploadBlog, icon: Icon(Icons.done_outline)),
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
              MaterialPageRoute(builder: (_) => BlogPage()),
              ((route) => false),
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    // after that supabase blog sql added and create blog table
                    image != null
                        ? GestureDetector(
                            onTap: () {
                              selectedImage();
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(25),
                              child: SizedBox(
                                height: 200,
                                child: Image.file(
                                  image!,
                                  height: 150,
                                  width: double.maxFinite,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: selectedImage,
                            child: SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  DottedBox(
                                    height: 200,
                                    width: double.infinity,
                                    borderShape: Shape.rectangle,
                                    borderRadius: 15,
                                    borderThickness: 2,
                                    borderColor: AppPallete.borderColor,
                                    space: 2,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,

                                    children: [
                                      Center(
                                        child: Icon(
                                          Icons.folder_open_outlined,
                                          size: 40,
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        'Select Your Image',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            [
                                  'Business',
                                  'Technology',
                                  'Programming',
                                  'Entertainment',
                                ]
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (selectedTopic.contains(e)) {
                                          selectedTopic.remove(e);
                                        } else {
                                          selectedTopic.add(e);
                                        }
                                        setState(() {});
                                        print(selectedTopic);
                                      },
                                      child: Chip(
                                        backgroundColor:
                                            selectedTopic.contains(e)
                                            ? AppPallete.gradient1
                                            : null,
                                        side: selectedTopic.contains(e)
                                            ? null
                                            : BorderSide(
                                                color: AppPallete.borderColor,
                                              ),
                                        label: Text(e),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),

                    SizedBox(height: 25),
                    BlogEditor(
                      controller: titleController,
                      hintText: 'Blog Title',
                    ),
                    SizedBox(height: 10),
                    BlogEditor(
                      controller: contentController,
                      hintText: 'Blog content',
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
