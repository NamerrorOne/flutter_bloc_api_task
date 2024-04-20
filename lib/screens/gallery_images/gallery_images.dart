import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GalleryImages extends StatefulWidget {
  const GalleryImages({super.key});

  @override
  State<GalleryImages> createState() => _GalleryImagesState();
}

class _GalleryImagesState extends State<GalleryImages> {
  List images = [];
  int page = 1;

  Future<void> _fetchPosts() async {
    final Dio dio = Dio();

    final Response response = await dio.get(
        'https://jsonplaceholder.typicode.com/photos?_page=$page&_limit=10');

    if (response.statusCode == 200) {
      var data = response.data;
      images.addAll(data);
      page++;

      print(images[1]['url']);
    }
  }

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchPosts();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.separated(
          itemCount: images.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: 10), // Расстояние между элементами
          itemBuilder: (context, index) {
            return Container(
              color: Colors.pink,
              height: 100,
              alignment: Alignment.center,
              child: Image.network(images[index]['url']),
            );
          },
          controller: _scrollController,
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _fetchPosts();
            },
            child: Icon(Icons.add),
          ),
          const SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.update),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text('Галерея'),
      ),
    );
  }
}
