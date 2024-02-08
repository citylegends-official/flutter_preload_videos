import 'package:flutter/material.dart';

typedef VideoPlayerNavigatorDetails = ({
  String title,
  int index,
  IconData icon,
});

enum VideoPlayerDetails {
  video_player((
    title: 'video_player',
    index: 0,
    icon: Icons.video_call_rounded,
  )),
  better_player((
    title: 'better_player',
    index: 1,
    icon: Icons.video_collection_rounded,
  )),
  media_kit((
    title: 'media_kit',
    index: 2,
    icon: Icons.video_settings_rounded,
  ));

  final VideoPlayerNavigatorDetails details;

  const VideoPlayerDetails(this.details);
}
