import 'package:flutter_photos/models/models.dart';
import 'package:flutter_photos/repositories/repositories.dart';

abstract class BasePhotosRepository extends BaseRepository {
  Future<List<Photo>> searchPhotos({String query, int page});
}
