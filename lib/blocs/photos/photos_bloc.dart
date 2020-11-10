import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_photos/models/models.dart';

part 'photos_event.dart';
part 'photos_state.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  PhotosBloc() : super(PhotosState.initial());

  @override
  Stream<PhotosState> mapEventToState(
    PhotosEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
