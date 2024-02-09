import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_preload_videos/utils/video_resource.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:video_player/video_player.dart';

/// Custom feed widget consisting video player and loading indicator.
///
/// The `VideoResourceController` is used to determine which video player to use.
class VideoWidget extends StatelessWidget {
  const VideoWidget({
    Key? key,
    required this.isLoading,
    required this.videoResourceController,
  });

  final bool isLoading;
  final VideoResourceController videoResourceController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: switch (videoResourceController) {
            VPController(:final controller) => _VideoPlayerViewer(
                controller: controller,
              ),
            BPController(:final controller) => _BetterPlayerViewer(
                controller: controller,
              ),
            MKController(:final controller) => _MediaKitViewer(
                controller: controller,
              ),
          },
        ),
        AnimatedCrossFade(
          alignment: Alignment.bottomCenter,
          sizeCurve: Curves.decelerate,
          duration: const Duration(milliseconds: 400),
          firstChild: Padding(
            padding: const EdgeInsets.all(32.0),
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          secondChild: const SizedBox.shrink(),
          crossFadeState:
              isLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        ),
      ],
    );
  }
}

class _VideoPlayerViewer extends StatelessWidget {
  const _VideoPlayerViewer({
    required this.controller,
  });

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(
            controller,
          ),
        ),
      ),
    );
  }
}

class _BetterPlayerViewer extends StatelessWidget {
  const _BetterPlayerViewer({
    required this.controller,
  });

  final BetterPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return BetterPlayer(
      controller: controller,
    );
  }
}

class _MediaKitViewer extends StatelessWidget {
  const _MediaKitViewer({
    required this.controller,
  });

  final VideoController controller;

  @override
  Widget build(BuildContext context) {
    return Video(
      controller: controller,
      fit: BoxFit.cover,
    );
  }
}
