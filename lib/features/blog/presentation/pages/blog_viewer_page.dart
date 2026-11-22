import 'package:blog_rivaan/core/theme/app_pallete.dart';
import 'package:blog_rivaan/core/utils/calculated_reading_time.dart';
import 'package:blog_rivaan/core/utils/date-formate.dart';
import 'package:blog_rivaan/core/utils/show_snackbar.dart';
import 'package:blog_rivaan/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogViewerPage extends StatefulWidget {
  final Blog blog;
  const BlogViewerPage({super.key, required this.blog});

  @override
  State<BlogViewerPage> createState() => _BlogViewerPageState();
}

class _BlogViewerPageState extends State<BlogViewerPage> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    final blog = widget.blog;
    final readingTime = calculatedReadingTime(blog.content);
    final authorName = (blog.posterName != null && blog.posterName!.trim().isNotEmpty)
        ? blog.posterName!
        : 'Community Writer';

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
        actions: [
          IconButton(
            tooltip: isBookmarked ? 'Remove Bookmark' : 'Bookmark',
            icon: Icon(
              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isBookmarked ? AppPallete.gradient2 : Colors.white70,
            ),
            onPressed: () {
              setState(() {
                isBookmarked = !isBookmarked;
              });
              showSnackbar(
                context,
                isBookmarked ? 'Story saved to bookmarks' : 'Bookmark removed',
              );
            },
          ),
          IconButton(
            tooltip: 'Share',
            icon: const Icon(Icons.share_outlined, color: Colors.white70),
            onPressed: () {
              showSnackbar(context, 'Article link ready to share');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Topic badges
              if (blog.topics.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: blog.topics.map((topic) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppPallete.gradient1.withValues(alpha: 0.3),
                            AppPallete.gradient2.withValues(alpha: 0.3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppPallete.gradient2.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        topic,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppPallete.gradient2,
                          letterSpacing: 0.3,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
              ],

              // Story Title
              Text(
                blog.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                  letterSpacing: -0.5,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 18),

              // Author & Publishing Metadata Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppPallete.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppPallete.borderColor),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppPallete.gradient1,
                      child: Text(
                        authorName[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authorName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 12,
                                color: AppPallete.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                dateFormatByDMMMYYY(blog.updated_at),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppPallete.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 3,
                                height: 3,
                                decoration: const BoxDecoration(
                                  color: AppPallete.textSecondary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.schedule_rounded,
                                size: 13,
                                color: AppPallete.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$readingTime min read',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppPallete.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Banner Image
              if (blog.image_url.isNotEmpty)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      blog.image_url,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          height: 220,
                          color: AppPallete.cardColor,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppPallete.gradient2,
                              strokeWidth: 2.5,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color: AppPallete.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppPallete.borderColor),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.broken_image_rounded,
                              size: 44,
                              color: AppPallete.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Blog Body Content with Classic Typography
              SelectableText(
                blog.content,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 17,
                  height: 1.85,
                  letterSpacing: 0.25,
                  color: Color.fromRGBO(235, 235, 245, 0.94),
                ),
              ),

              const SizedBox(height: 40),

              // Article End Divider & Thank You
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppPallete.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppPallete.borderColor),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 15,
                            color: AppPallete.gradient3,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'End of story',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppPallete.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
