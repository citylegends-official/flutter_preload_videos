import 'package:better_player/better_player.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:video_player/video_player.dart';

sealed class VideoResourceController {}

base class VPController implements VideoResourceController {
  final VideoPlayerController controller;

  VPController(this.controller);
}

base class BPController implements VideoResourceController {
  final BetterPlayerController controller;

  BPController(this.controller);
}

base class MKController implements VideoResourceController {
  final VideoController controller;

  MKController(this.controller);
}
