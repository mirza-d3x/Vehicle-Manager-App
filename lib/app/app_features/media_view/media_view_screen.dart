import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ImageMediaViewScreen extends StatefulWidget {
  final File imageFile;
  const ImageMediaViewScreen({required this.imageFile, super.key});

  @override
  State<ImageMediaViewScreen> createState() => _ImageMediaViewScreenState();
}

class _ImageMediaViewScreenState extends State<ImageMediaViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Image.file(widget.imageFile);
  }
}

class VideoMediaViewScreen extends StatefulWidget {
  final File videoFile;
  const VideoMediaViewScreen({required this.videoFile, super.key});

  @override
  State<VideoMediaViewScreen> createState() => _VideoMediaViewScreenState();
}

class _VideoMediaViewScreenState extends State<VideoMediaViewScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  VideoPlayer(_controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                  _ControlsOverlay(controller: _controller),
                ],
              ),
            )
          : const CircularProgressIndicator(),
    );
  }
}

class _ControlsOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  const _ControlsOverlay({required this.controller});

  @override
  State<_ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<_ControlsOverlay> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.controller.value.isPlaying
            ? widget.controller.pause()
            : widget.controller.play();
        setState(() {});
      },
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Icon(
            widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 60,
          ),
        ),
      ),
    );
  }
}
