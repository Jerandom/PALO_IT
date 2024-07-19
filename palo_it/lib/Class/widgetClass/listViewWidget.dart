import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../managerClass/ImageManager.dart';



class ListViewWidget extends StatelessWidget {
  const ListViewWidget({
  super.key,
    required this.images,
    required this.isLoading,
  });

  final List<dynamic> images;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: images.length + 1,
      itemBuilder: (context, index) {
        if (index == images.length) {
          return isLoading ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink();
        }
        final image = images[index];
        return InkWell(
          onTap: () {
            _showOptionsDialog(context, image['download_url']);
          },
          child: Card(
            elevation: 2, // Set the elevation for the Card
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: CachedNetworkImage(
              imageUrl: image['download_url'],
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        );
      }
    );
  }

  void _showOptionsDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Options'),
          content: const Text('Would you like to save or share this image?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
                downloadAndSaveImage(imageUrl, "image.png");
              },
            ),
            TextButton(
              child: const Text('Share'),
              onPressed: () {
                Navigator.of(context).pop();
                shareImage(imageUrl);
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}