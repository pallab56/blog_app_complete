import 'dart:io';

import 'package:blog_rivaan/core/error/exceptions.dart';
import 'package:blog_rivaan/core/error/failures.dart';
import 'package:blog_rivaan/core/network/connection_checker.dart';
import 'package:blog_rivaan/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_rivaan/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_rivaan/features/blog/data/model/blog_model.dart';
import 'package:blog_rivaan/features/blog/domain/entities/blog.dart';
import 'package:blog_rivaan/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final InternetConnectionChecker internetConnectionChecker;
  BlogRepositoryImpl({
    required this.blogRemoteDataSource,
    required this.blogLocalDataSource,
    required this.internetConnectionChecker,
  });
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await (internetConnectionChecker.isConnected)) {
        return left(Failure(msg: 'No Internet Connection!!!'));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        poster_id: posterId,
        title: title,
        content: content,
        image_url: '',
        topics: topics,
        updated_at: DateTime.now(),
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(image_url: imageUrl);

      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);

      return right(uploadedBlog);
    } on ServerExceptions catch (e) {
      return left(Failure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
    final isConnected = await internetConnectionChecker.isConnected;
    print('INTERNET CONNECTED: $isConnected');

    if (!isConnected) {
      final blogs = blogLocalDataSource.loadBlogs();
      print('LOCAL BLOGS LOADED: ${blogs.length}');
      return right(blogs);
    }

    final blogs = await blogRemoteDataSource.getAllBlogs();
    print('REMOTE BLOGS FETCHED: ${blogs.length}');
    blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
    return right(blogs);
  } on ServerExceptions catch (e) {
    return left(Failure(msg: e.msg));
  } catch (e) {
    print('UNEXPECTED ERROR: $e');
    return left(Failure(msg: e.toString()));
  }
  }
}
