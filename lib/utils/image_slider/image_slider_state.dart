class ImageSliderState {
  int indexPage;
  List<String>? imageList;
  ImageSliderState({this.indexPage = 0, this.imageList});

  ImageSliderState copyWith({int? indexPage, List<String>? imageList}) {
    return ImageSliderState(
        indexPage: indexPage ?? this.indexPage,
        imageList: imageList ?? this.imageList);
  }
}
