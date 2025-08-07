import 'package:flutter/material.dart';







class QuotesPage extends StatelessWidget {
  const QuotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quotes Page")),
      body: Center(child: const Text("Quotes Page Content Goes Here")),
    );
  }
}