import 'dart:io';

import 'package:blog_rivaan/core/error/exceptions.dart';
import 'package:blog_rivaan/core/error/failures.dart';
import 'package:blog_rivaan/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_rivaan/features/blog/data/model/blog_model.dart';
import 'package:blog_rivaan/features/blog/domain/entities/blog.dart';
import 'package:blog_rivaan/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;

  BlogRepositoryImpl({required this.blogRemoteDataSource});
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
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
}
