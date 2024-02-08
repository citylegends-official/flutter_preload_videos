import 'package:flutter/material.dart';
import 'package:flutter_preload_videos/feature/home/utils/navigation_details.dart';
import 'package:flutter_preload_videos/feature/video_player/page/video_player_page.dart';

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
        onPressed: () {},
        child: const Icon(
          Icons.query_stats_rounded,
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
        VideoPlayerDetails.better_player => null,
        VideoPlayerDetails.media_kit => null,
      },
    );
  }
}
