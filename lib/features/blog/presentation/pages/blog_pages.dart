import 'package:blog_rivaan/core/common/widgets/loader.dart';
import 'package:blog_rivaan/core/theme/app_pallete.dart';
import 'package:blog_rivaan/core/utils/show_snackbar.dart';
import 'package:blog_rivaan/features/blog/domain/usecases/get_all_blogs.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BLogFetchAllBlogs());
  }

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

      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return Loader();
          }
          if (state is BlogDisplaySuccess) {
            return ListView.builder(
              itemCount: state.blog.length,
              itemBuilder: (context, index) {
                final blog = state.blog[index];
                return BlogCard(blog: blog, color:index % 3 == 0? AppPallete.gradient1: index%3 == 1?AppPallete.gradient2:AppPallete.gradient3);
              },
            );
          }
          return Text('Nothing to show');
        },
      ),
    );
  }
}
