import 'package:blog_rivaan/core/common/widgets/loader.dart';
import 'package:blog_rivaan/core/theme/app_pallete.dart';
import 'package:blog_rivaan/core/utils/show_snackbar.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          const SizedBox(width: 8),
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
    );
  }
}
