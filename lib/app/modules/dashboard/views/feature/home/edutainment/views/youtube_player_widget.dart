import 'dart:async';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  final String videoId;
  final VoidCallback? onVideoEnded;

  const YoutubePlayerWidget({
    super.key,
    required this.videoId,
    this.onVideoEnded,
  });

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;

  bool isEndedTriggered = false;
  Duration _lastAllowedPosition = Duration.zero;
  Duration _watchedDuration = Duration.zero;

  Timer? _watchTimer;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: true, 
        hideControls: false,
      ),
    )..addListener(_listener);

    _watchTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_controller.value.isPlaying) {
        _watchedDuration += const Duration(seconds: 1);
      }
    });
  }

  void _listener() {
    if (!_controller.value.isReady) return;

    final position = _controller.value.position;
    final totalDuration = _controller.metadata.duration;

    if (position > _lastAllowedPosition + const Duration(seconds: 2)) {
      _controller.seekTo(_lastAllowedPosition);
      return;
    }
    _lastAllowedPosition = position;
    if (!isEndedTriggered &&
        _controller.value.playerState == PlayerState.ended) {
      isEndedTriggered = true;
      if (_watchedDuration.inSeconds >= totalDuration.inSeconds - 3) {
      print("SELESAI");
        widget.onVideoEnded?.call();
      }
    }
  }

  @override
  void dispose() {
    _watchTimer?.cancel();
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.orange,
      progressColors: const ProgressBarColors(
        playedColor: Colors.orange,
        handleColor: Colors.orangeAccent,
      ),
    );
  }
}
