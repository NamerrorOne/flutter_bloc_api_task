import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery/screens/gallery_images/gallery_images_bloc/gallery_images_event.dart';
import 'package:image_gallery/screens/gallery_images/gallery_images_bloc/gallery_images_state.dart';
import 'package:image_gallery/services/api_config.dart';

class GalleryImagesBloc
    extends Bloc<GalleryImagesBaseEvent, GalleryImagesBaseState> {
  List<String> images = [];
  int page = 1;
  int limit = 10;

  GalleryImagesBloc() : super(InitState()) {
    on<GetImagesEvent>(_getImages);
    on<DeletedImagesEvent>(_deleteImages);
  }

  FutureOr<void> _getImages(GetImagesEvent event, Emitter emit) async {
    emit(ImagesLoadingState());

    try {
      final Dio dio = Dio();
      final Response response = await dio.get(
        'https://api.thecatapi.com/v1/images/search?api_key=${ApiConfig.apiKey}&limit=$limit&page=$page',
      );

      if (response.statusCode == 200) {
        List data = response.data;
        for (var imageData in data) {
          images.add(imageData['url']);
        }

        if (response.statusCode != 200) {
          emit(GalleryErrorState(
              errorMessage: 'Status code is error : ${response.statusCode}'));
          throw Exception(response.statusCode);
        }

        page++;
        emit(GetImagesState(images: images.toList()));
      } else {
        emit(GalleryErrorState(errorMessage: 'Ошибка при загрузке данных'));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response);
        emit(GalleryErrorState(errorMessage: e.response.toString()));
      } else {
        print(e.requestOptions);

        emit(GalleryErrorState(errorMessage: e.message.toString()));
      }
    } catch (e) {
      emit(GalleryErrorState(errorMessage: 'Произошла ошибка: $e'));
    }
  }

  _deleteImages(event, emit) {
    images = [];
    page = 1;
    emit(ImagesDeletedState(images: images));
  }
}
