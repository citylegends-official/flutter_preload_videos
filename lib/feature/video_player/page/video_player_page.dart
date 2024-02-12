import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preload_videos/feature/video_player/bloc/vp_bloc.dart';
import 'package:flutter_preload_videos/shared/video_widget.dart';
import 'package:flutter_preload_videos/utils/video_resource.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage();

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VPBloc, VPState>(
      builder: (context, state) {
        return PageView.builder(
          itemCount: state.urls.length,
          scrollDirection: Axis.vertical,
          onPageChanged: (index) => BlocProvider.of<VPBloc>(context).add(
            VPEvent.onVideoIndexChanged(index),
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
        );
      },
    );
  }
}
