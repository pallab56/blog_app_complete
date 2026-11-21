import 'package:blog_rivaan/features/blog/presentation/pages/add_neew_blog_page.dart';
import 'package:flutter/material.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Blog App")),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNeewBlogPage.route());
            },
            icon: Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }
}
