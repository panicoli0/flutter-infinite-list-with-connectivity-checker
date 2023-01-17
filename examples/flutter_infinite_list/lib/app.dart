import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/bloc/network_bloc.dart';
import 'package:flutter_infinite_list/posts/posts.dart';

class App extends MaterialApp {
  const App({super.key}) : super(home: const PostHome());
}

class PostHome extends StatelessWidget {
  const PostHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NetworkBloc()..add(NetworkObserve()),
      child: const PostsPage(),
    );
  }
}
