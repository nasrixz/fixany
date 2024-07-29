import 'dart:io';

import 'package:flutter/material.dart';

class PreviewPage extends StatefulWidget {
  final String? imagePath;
  final String? videoPath;

  const PreviewPage({super.key, this.imagePath, this.videoPath});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Image.file(
        File(widget.imagePath ?? ""),
        fit: BoxFit.cover,
      )),
    );
  }
}
