part of 'photos_bloc.dart';

abstract class PhotosEvent extends Equatable {
  const PhotosEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class PhotosSearchPhotos extends PhotosEvent {
  final String query;

  const PhotosSearchPhotos({@required this.query});

  @override
  List<Object> get props => [query];
}

class PhotosPaginate extends PhotosEvent {}
