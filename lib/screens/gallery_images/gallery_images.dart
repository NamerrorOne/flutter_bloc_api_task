import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery/components/flame_text.dart';
import 'package:image_gallery/screens/gallery_images/gallery_images_bloc/gallery_images_bloc.dart';
import 'package:image_gallery/screens/gallery_images/gallery_images_bloc/gallery_images_event.dart';
import 'package:image_gallery/screens/gallery_images/gallery_images_bloc/gallery_images_state.dart';

class GalleryImages extends StatefulWidget {
  const GalleryImages({super.key});

  @override
  State<GalleryImages> createState() => _GalleryImagesState();
}

class _GalleryImagesState extends State<GalleryImages> {
  final bloc = GalleryImagesBloc();
  List<String> images = [];

  final ScrollController _scrollController = ScrollController();

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
      bloc.add(GetImagesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: bloc,
      builder: (BuildContext context, state) {
        if (state is GalleryErrorState) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 450,
                  color: const Color.fromARGB(255, 198, 172, 180),
                  child: Center(
                      child: Text(state.errorMessage,
                          style: TextStyle(fontSize: 40)))),
            ),
          );
        }
        if (state is ImagesLoadingState) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: images.length + 1,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      if (index == images.length) {
                        return const Center(
                            child: Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 177, 255, 59),
                          ),
                        ));
                      }
                      return Container(
                        color: Colors.black,
                        alignment: Alignment.center,
                        child: InkWell(
                          child: Image.network(
                            images[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        if (state is GetImagesState) {
          images = state.images;
        }

        if (state is ImagesDeletedState) {
          images = state.images;
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: images.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: Image.network(
                        images[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: () {
                  bloc.add(GetImagesEvent());
                },
                child: const Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 177, 255, 59),
                ),
              ),
              const SizedBox(width: 20),
              FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: () {
                  bloc.add(DeletedImagesEvent());
                },
                child: const Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 177, 255, 59),
                ),
              ),
            ],
          ),
          appBar: AppBar(
            title: FlameText(),
            backgroundColor: Colors.black,
          ),
        );
      },
    );
  }
}
