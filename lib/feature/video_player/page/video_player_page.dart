import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preload_videos/feature/video_player/bloc/vp_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage();

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late final VPBloc _vpBloc;

  @override
  void initState() {
    super.initState();

    _vpBloc = BlocProvider.of<VPBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _vpBloc
      ..add(
        const VPEvent.disposeAllControllers(),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VPBloc, VPState>(
        builder: (context, state) {
          return PageView.builder(
            itemCount: state.urls.length,
            scrollDirection: Axis.vertical,
            onPageChanged: (index) => _vpBloc
              ..add(
                VPEvent.onVideoIndexChanged(
                  index,
                ),
              ),
            itemBuilder: (context, index) {
              final bool _isLoading =
                  (state.isLoading && index == state.urls.length - 1);

              return state.focusedIndex == index &&
                      state.controllers[index] != null
                  ? VideoWidget(
                      isLoading: _isLoading,
                      controller: state.controllers[index]!,
                    )
                  : const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}

/// Custom feed widget consisting video
class VideoWidget extends StatelessWidget {
  const VideoWidget({
    Key? key,
    required this.isLoading,
    required this.controller,
  });

  final bool isLoading;
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(
                  controller..setLooping(true),
                ),
              ),
            ),
          ),
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
