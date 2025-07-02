import 'package:findyf_app/commons/models/postagem_model.dart';
import 'package:findyf_app/home/controllers/home_controller.dart';
import 'package:findyf_app/home/widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';

class FeedPage extends StatefulWidget {
  FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final HomeController homeController = Get.find();
  final ScrollController _scrollController = ScrollController();
  List<PostagemModel> displayedPosts = [];
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadMorePosts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMorePosts();
      }
    });
  }

  void _loadMorePosts() {
    List<PostagemModel> newPosts =
        homeController.getPaginatedPostagens(currentPage);
    if (newPosts.isNotEmpty) {
      setState(() {
        displayedPosts.addAll(newPosts);
        currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: displayedPosts.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            PostWidget(postagem: displayedPosts[index]),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
