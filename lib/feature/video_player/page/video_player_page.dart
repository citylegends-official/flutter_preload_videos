import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preload_videos/feature/home/utils/navigation_details.dart';
import 'package:flutter_preload_videos/feature/video_player/bloc/vp_bloc.dart';
import 'package:flutter_preload_videos/shared/video_widget.dart';
import 'package:flutter_preload_videos/utils/injection.dart';
import 'package:flutter_preload_videos/utils/video_resource.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage();

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late final _videoPlayerDetails = VideoPlayerDetails.video_player;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VPBloc>()
        ..add(
          VPEvent.getVideosFromApi(),
        ),
      child: BlocBuilder<VPBloc, VPState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                _videoPlayerDetails.details.title,
              ),
            ),
            body: PageView.builder(
              itemCount: state.urls.length,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) => BlocProvider.of<VPBloc>(context)
                ..add(
                  VPEvent.onVideoIndexChanged(
                    index,
                  ),
                ),
              itemBuilder: (context, index) {
                final bool _isLoading =
                    (state.isLoading && index == state.urls.length - 1);

                return state.focusedIndex == index
                    ? VideoWidget(
                        isLoading: _isLoading,
                        videoResourceController: VPController(
                          state.controllers[index]!,
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
