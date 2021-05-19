import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_photos/blocs/blocs.dart';
import 'package:flutter_photos/widgets/widgets.dart';

class PhotosScreen extends StatefulWidget {
  @override
  _PhotosScreenState createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset ==
                _scrollController.position.maxScrollExtent &&
            context.read<PhotosBloc>().state.status !=
                PhotosStatus.paginating) {
          context.read<PhotosBloc>().add(PhotosPaginate());
        }
      });
  }

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
            if (state.status == PhotosStatus.paginating) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Loading more photos...'),
                  duration: Duration(seconds: 1),
                ),
              );
            } else if (state.status == PhotosStatus.noMorePhotos) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('No more photos.'),
                  duration: Duration(milliseconds: 1500),
                ),
              );
            } else if (state.status == PhotosStatus.error) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Search Error'),
                  content: Text(state.failure!.message),
                  actions: [
                    TextButton(
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
                    Expanded(
                      child: state.photos.isNotEmpty
                          ? GridView.builder(
                              controller: _scrollController,
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
