import 'package:flutter/material.dart';
import 'package:flutter_photos/models/models.dart';
import 'package:flutter_photos/repositories/repositories.dart';
import 'package:flutter_photos/widgets/widgets.dart';

class PhotosScreen extends StatefulWidget {
  @override
  _PhotosScreenState createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  String _query = 'programming';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Photos'),
        ),
        body: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                fillColor: Colors.white,
                filled: true,
              ),
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  setState(() => _query = val.trim());
                }
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: PhotosRepository().searchPhotos(query: _query),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final List<Photo> photos = snapshot.data;
                    return GridView.builder(
                      padding: const EdgeInsets.all(20.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 15.0,
                        crossAxisSpacing: 15.0,
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index) {
                        final photo = photos[index];
                        return PhotoCard(photo: photo);
                      },
                      itemCount: photos.length,
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
