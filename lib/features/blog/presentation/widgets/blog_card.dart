// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blog_rivaan/core/theme/app_pallete.dart';
import 'package:blog_rivaan/core/utils/calculated_reading_time.dart';
import 'package:blog_rivaan/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';

import 'package:blog_rivaan/features/blog/domain/entities/blog.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>BlogViewerPage(blog: blog,)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        padding: EdgeInsets.all(12),
        height: 200,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: blog.topics
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Chip(
                              backgroundColor: AppPallete.transparentColor,
                            
                              side: BorderSide(color: AppPallete.borderColor),
                              label: Text(e),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Text(blog.title , style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
              ],
            ),
      
            Text('${calculatedReadingTime(blog.content)} min',style: TextStyle(fontSize: 12),),
          ],
        ),
      ),
    );
  }
}
