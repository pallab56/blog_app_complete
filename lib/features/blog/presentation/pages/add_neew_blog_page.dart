import 'package:blog_rivaan/core/theme/app_pallete.dart';
import 'package:blog_rivaan/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_box/dotted_box.dart';
import 'package:flutter/material.dart';

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
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.done_outline))],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
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
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        Center(
                          child: Icon(Icons.folder_open_outlined, size: 40),
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
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      ['Business', 'Technology', 'Programming', 'Entertainment']
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
                                  backgroundColor: selectedTopic.contains(e)?AppPallete.gradient1:null,
                                  side:selectedTopic.contains(e)?null: BorderSide(
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
              BlogEditor(controller: titleController, hintText: 'Blog Title'),
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
  }
}
