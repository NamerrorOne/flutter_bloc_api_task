import 'package:flutter/material.dart';
import 'package:image_gallery/screens/gallery_images/gallery_images.dart';

void main() {
  runApp(GalleryApp());
}

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GalleryImages(),
    );
  }
}
