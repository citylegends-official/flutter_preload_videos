import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preload_videos/feature/better_player/bloc/bp_bloc.dart';
import 'package:flutter_preload_videos/shared/video_widget.dart';
import 'package:flutter_preload_videos/utils/video_resource.dart';

class BetterPlayerPage extends StatefulWidget {
  const BetterPlayerPage();

  @override
  State<BetterPlayerPage> createState() => _BetterPlayerPageState();
}

class _BetterPlayerPageState extends State<BetterPlayerPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BPBloc, BPState>(
      builder: (context, state) {
        return PageView.builder(
          itemCount: state.urls.length,
          scrollDirection: Axis.vertical,
          onPageChanged: (index) => BlocProvider.of<BPBloc>(context)
            ..add(
              BPEvent.onVideoIndexChanged(
                index,
              ),
            ),
          itemBuilder: (context, index) {
            final bool _isLoading =
                (state.isLoading && index == state.urls.length - 1);

            return state.focusedIndex == index
                ? VideoWidget(
                    isLoading: _isLoading,
                    videoResourceController: BPController(
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
