import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// A reusable, looping, muted video background.
// Pass in any asset path, and it fills the screen behind your content.
class VideoBackground extends StatefulWidget {
  final String assetPath;
  final Widget child;

  const VideoBackground({
    super.key,
    required this.assetPath,
    required this.child,
  });

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground> {
  VideoPlayerController? _controller;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final controller = VideoPlayerController.asset(widget.assetPath);
    try {
      await controller.initialize();
      controller.setLooping(true);
      controller.setVolume(0); // muted, since it's just ambient motion
      controller.play();
      if (mounted) {
        setState(() {
          _controller = controller;
          _isReady = true;
        });
      }
    } catch (e) {
      // If the video fails to load for any reason, we simply show
      // a plain background instead of crashing the app.
      if (mounted) {
        setState(() {
          _isReady = false;
        });
      }
    }
  }

  @override
  void didUpdateWidget(VideoBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the asset path changes (e.g. switching from story to quiz
    // background), swap out the video cleanly.
    if (oldWidget.assetPath != widget.assetPath) {
      _controller?.dispose();
      _isReady = false;
      _initVideo();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Fallback solid color, visible while video loads or if it fails.
        Container(color: const Color(0xFFFFF4E0)),
        // Subtle spinner while the video initialises so kids don't see
        // a silent colour flash on slower devices.
        if (!_isReady)
          const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFFF6F61),
              strokeWidth: 2.5,
            ),
          ),
        if (_isReady && _controller != null)
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          ),
        widget.child,
      ],
    );
  }
}