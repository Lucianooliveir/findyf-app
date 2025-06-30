import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => {},
              child: Container(
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundImage: Image.asset("assets/images/pfp.png").image,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text("Nome"),
          ],
        ),
        CachedNetworkImage(
          imageUrl: "http://localhost:8080/uploads/pfp/1748612754118.jpg",
          height: 50,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        const Row()
      ],
    );
  }
}
