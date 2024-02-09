import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preload_videos/feature/home/utils/navigation_details.dart';
import 'package:flutter_preload_videos/feature/media_kit/bloc/mk_bloc.dart';
import 'package:flutter_preload_videos/shared/video_widget.dart';
import 'package:flutter_preload_videos/utils/injection.dart';
import 'package:flutter_preload_videos/utils/video_resource.dart';

class MediaKitPage extends StatefulWidget {
  const MediaKitPage();

  @override
  State<MediaKitPage> createState() => _MediaKitPageState();
}

class _MediaKitPageState extends State<MediaKitPage> {
  late final _videoPlayerDetails = VideoPlayerDetails.media_kit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MKBloc>()
        ..add(
          MKEvent.getVideosFromApi(),
        ),
      child: BlocBuilder<MKBloc, MKState>(
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
              onPageChanged: (index) => BlocProvider.of<MKBloc>(context)
                ..add(
                  MKEvent.onVideoIndexChanged(
                    index,
                  ),
                ),
              itemBuilder: (context, index) {
                final bool _isLoading =
                    (state.isLoading && index == state.urls.length - 1);

                return state.focusedIndex == index
                    ? VideoWidget(
                        isLoading: _isLoading,
                        videoResourceController: MKController(
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
