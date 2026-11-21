import 'package:blog_rivaan/core/utils/calculated_reading_time.dart';
import 'package:blog_rivaan/core/utils/date-formate.dart';
import 'package:blog_rivaan/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogViewerPage extends StatelessWidget {
  final Blog blog;
  const BlogViewerPage({super.key ,required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(blog.title ,style: TextStyle(fontSize: 24,fontWeight: FontWeight.w700),),
            
                SizedBox(height: 20,),
            
                Text('Author By : ${blog.posterName}' ,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
                SizedBox(height: 5,),
                Text('${dateFormatByDMMMYYY(blog.updated_at)} . ${calculatedReadingTime(blog.content)} min',style: TextStyle(fontSize: 11),),
                SizedBox  (height: 20,),
            
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(22),
                    child: Image.network(blog.image_url,fit: BoxFit.cover,)),
                ),
                SizedBox(height: 10,),
                Text(blog.content,style: TextStyle(fontSize: 16,height: 2),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
