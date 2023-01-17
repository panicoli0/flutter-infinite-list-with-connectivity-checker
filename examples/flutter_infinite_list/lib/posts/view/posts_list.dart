import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/bloc/network_bloc.dart';
import 'package:flutter_infinite_list/posts/posts.dart';

class PostsList extends StatefulWidget {
  const PostsList({super.key});

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkBloc, NetworkState>(
      listenWhen: (previous, current) {
        return previous is NetworkFailure && current is NetworkSuccess;
      },
      listener: (context, state) {
        print("FETCHING AGAIN...");
        context.read<PostBloc>().add(PostFetched());
      },
      child: StreamBuilder<List<Post>>(
        stream: context.read<PostBloc>().postController.stream,
        builder: (context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.hasData) {
            var posts = snapshot.data!;
            if (snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return index >= posts.length
                      ? const BottomLoader()
                      : PostListItem(post: posts[index]);
                },
                itemCount: context.read<PostBloc>().hasReachedMax
                    ? posts.length
                    : posts.length + 1,
                controller: _scrollController,
              );
            } else {
              return const Center(child: Text('no posts'));
            }
          } else {
            return const Center(child: Text('failed to fetch posts'));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    //At this point you should check your app's network status before try to fetch
    //posts
    if (_isBottom) context.read<PostBloc>().add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
