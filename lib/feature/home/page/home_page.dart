import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preload_videos/feature/better_player/page/bettter_player_page.dart';
import 'package:flutter_preload_videos/feature/home/utils/navigation_details.dart';
import 'package:flutter_preload_videos/feature/media_kit/page/media_kit_page.dart';
import 'package:flutter_preload_videos/feature/video_player/page/video_player_page.dart';
import 'package:flutter_preload_videos/shared/fps_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerDetails _videoPlayerDetails;

  @override
  void initState() {
    super.initState();

    _videoPlayerDetails = VideoPlayerDetails.video_player;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<FpsCubit>().toggleFps(),
        child: Icon(
          context.read<FpsCubit>().state
              ? Icons.disabled_visible_rounded
              : Icons.query_stats_rounded,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _videoPlayerDetails.details.index,
        onTap: (index) {
          final _tmp = switch (index) {
            0 => VideoPlayerDetails.video_player,
            1 => VideoPlayerDetails.better_player,
            2 => VideoPlayerDetails.media_kit,
            _ => null,
          };

          if (_tmp != null)
            setState(() {
              _videoPlayerDetails = _tmp;
            });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(VideoPlayerDetails.video_player.details.icon),
            label: VideoPlayerDetails.video_player.details.title,
          ),
          BottomNavigationBarItem(
            icon: Icon(VideoPlayerDetails.better_player.details.icon),
            label: VideoPlayerDetails.better_player.details.title,
          ),
          BottomNavigationBarItem(
            icon: Icon(VideoPlayerDetails.media_kit.details.icon),
            label: VideoPlayerDetails.media_kit.details.title,
          ),
        ],
      ),
      body: switch (_videoPlayerDetails) {
        VideoPlayerDetails.video_player => VideoPlayerPage(),
        VideoPlayerDetails.better_player => BetterPlayerPage(),
        VideoPlayerDetails.media_kit => MediaKitPage(),
      },
    );
  }
}
