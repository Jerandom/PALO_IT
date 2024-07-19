import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';

Future<List<dynamic>> fetchImages(int page, int limit) async {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  try {
    final response = await dio.get(
      'https://picsum.photos/v2/list',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    }
    else {
      throw Exception('Invalid Response');
    }
  }
  on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
      throw Exception("Request timed out");
    }
    else {
      throw Exception("Request failed: $e");
    }
  }
}

Future<void> downloadAndSaveImage(String url, String filename) async {
  try {
    final response = await Dio().get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    // Get the temporary directory
    final tempDir = await getTemporaryDirectory();
    final savePath = '${tempDir.path}/$filename';

    // Save the image temporarily
    final file = File(savePath);
    await file.writeAsBytes(response.data!);

    // Save the image to the gallery
    await GallerySaver.saveImage(file.path, albumName: 'MyAppImages');
  }
  catch (e) {
    throw Exception('Error downloading image: $e');
  }
}

void shareImage(String imageUrl) async {
  try {
    await Share.share(imageUrl);
  }
  catch (e) {
    throw Exception("Error sharing image: $e");
  }
}
