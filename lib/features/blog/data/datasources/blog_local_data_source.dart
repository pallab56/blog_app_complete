import 'package:blog_rivaan/features/blog/data/model/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;
  BlogLocalDataSourceImpl({required this.box});
  @override
  List<BlogModel> loadBlogs() {
    print('BOX LENGTH IN LOAD: ${box.length}, KEYS: ${box.keys}');
    List<BlogModel> blogs = [];
    for (int i = 0; i < box.length; i++) {
      final blogJson = box.get(i.toString());
      if (blogJson != null) {
        blogs.add(BlogModel.fromJson(Map<String, dynamic>.from(blogJson)));
      }
    }
    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) async{
    await box.clear();
    for (int i = 0; i < blogs.length; i++) {
    await box.put(i.toString(), blogs[i].toJson());
    }
     print('SAVED TO HIVE: ${box.length}');
  }
}
