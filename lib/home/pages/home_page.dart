import 'package:findyf_app/home/widgets/post_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "adicionar")
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [PostWidget()],
        ),
      ),
    );
  }
}
