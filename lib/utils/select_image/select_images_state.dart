part of 'select_images_cubit.dart';

class SelectImagesState {
  List<Medium> media;
  List<Album> albumList;
  Album? currentAlbum;
  List<Medium> selectedImages;
  bool loadingMore;
  bool loading;

  SelectImagesState({
    this.media = const [],
    this.currentAlbum,
    this.albumList = const [],
    this.selectedImages = const [],
    this.loadingMore = false,
    this.loading = false,
  });

  SelectImagesState copyWith({
    List<Medium>? media,
    List<Album>? albumList,
    Album? currentAlbum,
    List<Medium>? selectedImages,
    bool? loadingMore,
    bool? loading,
  }) {
    return SelectImagesState(
      media: media ?? this.media,
      albumList: albumList ?? this.albumList,
      currentAlbum: currentAlbum ?? this.currentAlbum,
      selectedImages: selectedImages ?? this.selectedImages,
      loadingMore: loadingMore ?? this.loadingMore,
      loading: loading ?? this.loading,
    );
  }
}
