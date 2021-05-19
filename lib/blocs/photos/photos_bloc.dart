import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_photos/models/models.dart';
import 'package:flutter_photos/repositories/repositories.dart';

part 'photos_event.dart';
part 'photos_state.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  final PhotosRepository _photosRepository;

  PhotosBloc({required PhotosRepository photosRepository})
      : _photosRepository = photosRepository,
        super(PhotosState.initial());

  @override
  Future<void> close() {
    _photosRepository.dispose();
    return super.close();
  }

  @override
  Stream<PhotosState> mapEventToState(
    PhotosEvent event,
  ) async* {
    if (event is PhotosSearchPhotos) {
      yield* _mapPhotosSearchPhotosToState(event);
    } else if (event is PhotosPaginate) {
      yield* _mapPhotosPaginateToState();
    }
  }

  Stream<PhotosState> _mapPhotosSearchPhotosToState(
    PhotosSearchPhotos event,
  ) async* {
    yield state.copyWith(query: event.query, status: PhotosStatus.loading);
    try {
      final photos = await _photosRepository.searchPhotos(query: event.query);
      yield state.copyWith(photos: photos, status: PhotosStatus.loaded);
    } catch (err) {
      print(err);
      yield state.copyWith(
        failure: Failure(
          message: 'Something went wrong! Please try a different search',
        ),
        status: PhotosStatus.error,
      );
    }
  }

  Stream<PhotosState> _mapPhotosPaginateToState() async* {
    yield state.copyWith(status: PhotosStatus.paginating);

    final photos = List<Photo>.from(state.photos);
    List<Photo> nextPhotos = [];
    if (photos.length >= PhotosRepository.numPerPage) {
      nextPhotos = await _photosRepository.searchPhotos(
          query: state.query,
          page: state.photos.length ~/ PhotosRepository.numPerPage + 1);
    }
    yield state.copyWith(
      photos: photos..addAll(nextPhotos),
      status: nextPhotos.isNotEmpty
          ? PhotosStatus.loaded
          : PhotosStatus.noMorePhotos,
    );
  }
}
