import 'package:equatable/equatable.dart';

abstract class GalleryImagesBaseState extends Equatable {
  @override
  List get props => [];
}

class InitState extends GalleryImagesBaseState {}

class GetImagesState extends GalleryImagesBaseState {
  GetImagesState({required this.images});

  final List<String> images;
  @override
  List get props => [images];
}

class ImagesLoadingState extends GalleryImagesBaseState {
  ImagesLoadingState();
}

class ImagesDeletedState extends GalleryImagesBaseState {
  ImagesDeletedState({required this.images});
  final List<String> images;
  @override
  List get props => [images];
}

class GalleryErrorState extends GalleryImagesBaseState {
  GalleryErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List get props => [errorMessage];
}
