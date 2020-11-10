import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_photos/blocs/blocs.dart';
import 'package:flutter_photos/repositories/repositories.dart';
import 'package:flutter_photos/screens/screens.dart';

void main() {
  EquatableConfig.stringify = kDebugMode;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PhotosRepository(),
      child: BlocProvider(
        create: (context) => PhotosBloc(
          photosRepository: context.read<PhotosRepository>(),
        )..add(PhotosSearchPhotos(query: 'programming')),
        child: MaterialApp(
          title: 'Flutter Photos App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: PhotosScreen(),
        ),
      ),
    );
  }
}
