import 'package:flutter/material.dart';

class MediaCaptureLoadingComponent extends StatelessWidget {
  const MediaCaptureLoadingComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
