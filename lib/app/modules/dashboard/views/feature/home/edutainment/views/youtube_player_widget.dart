import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Widget reusable untuk memutar video YouTube.
///
/// ✅ Cara pakai:
/// ```dart
/// YoutubePlayerWidget(videoId: 'dQw4w9WgXcQ')
/// ```
class YoutubePlayerWidget extends StatefulWidget {
  final String videoId;
  final double height;

  const YoutubePlayerWidget({
    Key? key,
    required this.videoId,
    this.height = 200,
  }) : super(key: key);

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        controlsVisibleAtStart: true,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.orange,
      bottomActions: [
        CurrentPosition(),
        ProgressBar(isExpanded: true),
        RemainingDuration(),
        const PlaybackSpeedButton(),
      ],
    );
  }
}
