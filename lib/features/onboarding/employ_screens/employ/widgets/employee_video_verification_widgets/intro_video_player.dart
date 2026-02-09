import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class IntroVideoPlayer extends StatefulWidget {
  const IntroVideoPlayer({super.key});

  @override
  State<IntroVideoPlayer> createState() => _IntroVideoPlayerState();
}

class _IntroVideoPlayerState extends State<IntroVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    // The provided ID/URL
    // Note: The previous video (BciiXULbAuo) ALSO has embedding disabled.
    // YOU MUST USE A VIDEO THAT ALLOWS EMBEDDING.
    // To fix your own video: Go to YouTube Studio -> Details -> Show More -> Allow Embedding.
    // Currently using a safe public video (Flutter Widget of the Week) to prove the app works:
    const videoSource = 'https://youtu.be/20a9tq4ditc';

    // Attempt to extract ID if it's a URL, or use it as ID.
    // Convert 'nK6HhJgYwKSLIsIi' -> standard ID if possible.
    // Note: Standard IDs are 11 chars. If this is a shortened URL path or invalid, convertUrlToId might return null.
    // For specific user inputs, it's safer to try conversion.
    final videoId = YoutubePlayer.convertUrlToId(videoSource) ?? videoSource;
    debugPrint('Extracted Video ID: $videoId');

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: const ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
        // Add onReady to handle successful load
        onReady: () {
          // print('Player is ready.');
        },
      ),
    );
  }
}
