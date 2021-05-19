import 'package:equatable/equatable.dart';
import 'package:flutter_photos/models/models.dart';

class Photo extends Equatable {
  final String id;
  final String url;
  final String description;
  final User user;

  const Photo({
    required this.id,
    required this.url,
    required this.description,
    required this.user,
  });

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'],
      url: map['urls']['regular'],
      description: map['description'] ?? 'No description.',
      user: User.fromMap(map['user']),
    );
  }

  @override
  List<Object> get props => [id, url, description, user];

  @override
  bool get stringify => true;
}
