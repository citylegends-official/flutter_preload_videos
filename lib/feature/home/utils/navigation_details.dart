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
    icon: Icons.looks_one_rounded,
  )),
  better_player((
    title: 'better_player',
    index: 1,
    icon: Icons.looks_two_rounded,
  )),
  media_kit((
    title: 'media_kit',
    index: 2,
    icon: Icons.looks_3_rounded,
  ));

  final VideoPlayerNavigatorDetails details;

  const VideoPlayerDetails(this.details);
}
