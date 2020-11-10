import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_photos/blocs/blocs.dart';
import 'package:flutter_photos/widgets/widgets.dart';

class PhotosScreen extends StatefulWidget {
  @override
  _PhotosScreenState createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Photos'),
        ),
        body: BlocConsumer<PhotosBloc, PhotosState>(
          listener: (context, state) {
            if (state.status == PhotosStatus.error) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Search Error'),
                  content: Text(state.failure.message),
                  actions: [
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      onSubmitted: (val) {
                        if (val.trim().isNotEmpty) {
                          context
                              .read<PhotosBloc>()
                              .add(PhotosSearchPhotos(query: val.trim()));
                        }
                      },
                    ),
                    if (state.status == PhotosStatus.loaded)
                      Expanded(
                        child: state.photos.isNotEmpty
                            ? GridView.builder(
                                padding: const EdgeInsets.all(20.0),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 15.0,
                                  crossAxisSpacing: 15.0,
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.8,
                                ),
                                itemBuilder: (context, index) {
                                  final photo = state.photos[index];
                                  return PhotoCard(
                                    photos: state.photos,
                                    index: index,
                                    photo: photo,
                                  );
                                },
                                itemCount: state.photos.length,
                              )
                            : Center(
                                child: Text('No results.'),
                              ),
                      ),
                  ],
                ),
                if (state.status == PhotosStatus.loading)
                  CircularProgressIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }
}
