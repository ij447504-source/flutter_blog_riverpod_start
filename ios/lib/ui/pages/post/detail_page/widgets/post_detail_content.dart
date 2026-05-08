import 'package:flutter/material.dart';

class PostDetailContent extends StatelessWidget {
  final String content;

  const PostDetailContent(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Text(content),
    );
  }
}
