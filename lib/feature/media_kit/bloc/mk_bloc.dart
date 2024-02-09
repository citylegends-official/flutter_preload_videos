import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_preload_videos/service/api_service.dart';
import 'package:flutter_preload_videos/core/constants.dart';
import 'package:flutter_preload_videos/utils/isolate.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

part 'mk_bloc.freezed.dart';
part 'mk_event.dart';
part 'mk_state.dart';

@injectable
@prod
class MKBloc extends Bloc<MKEvent, MKState> {
  MKBloc() : super(MKState.initial()) {
    on(_mapEventToState);
  }

  @override
  Future<void> close() {
    log('[DISPOSE] Disposing the VP Bloc instance');
    return super.close();
  }

  void _mapEventToState(MKEvent event, Emitter<MKState> emit) async {
    await event.map(
      setLoading: (e) {
        emit(state.copyWith(isLoading: true));
      },
      getVideosFromApi: (e) async {
        /// Fetch first 5 videos from api
        final _urls = await ApiService.getVideos();
        state.urls.addAll(_urls);

        /// Initialize 1st video
        await _initializeControllerAtIndex(0);

        /// Play 1st video
        _playControllerAtIndex(0);

        /// Initialize 2nd video
        await _initializeControllerAtIndex(1);

        emit(state.copyWith(reloadCounter: state.reloadCounter + 1));
      },
      onVideoIndexChanged: (e) {
        /// Condition to fetch new videos
        final shouldFetch = (e.index + kPreloadLimit) % kNextLimit == 0 &&
            state.urls.length == e.index + kPreloadLimit;

        if (shouldFetch) {
          createIsolate(
            index: e.index,
            setLoading: (context) => this
              ..add(
                MKEvent.setLoading(),
              ),
            updateUrls: (urls) => this
              ..add(
                MKEvent.updateUrls(urls),
              ),
          );
        }

        /// Next / Prev video decider
        if (e.index > state.focusedIndex) {
          _playNext(e.index);
        } else {
          _playPrevious(e.index);
        }

        emit(state.copyWith(focusedIndex: e.index));
      },
      updateUrls: (e) {
        /// Add new urls to current urls
        state.urls.addAll(e.urls);

        /// Initialize new url
        _initializeControllerAtIndex(state.focusedIndex + 1);

        emit(state.copyWith(
          reloadCounter: state.reloadCounter + 1,
          isLoading: false,
        ));

        log('[ADD] New videos added');
      },
      disposeAllControllers: (e) {
        _disposeAllControllers();
      },
    );
  }

  void _playNext(int index) {
    /// Stop [index - 1] controller
    _stopControllerAtIndex(index - 1);

    /// Dispose [index - 2] controller
    _disposeControllerAtIndex(index - 2);

    /// Play current video (already initialized)
    _playControllerAtIndex(index);

    /// Initialize [index + 1] controller
    _initializeControllerAtIndex(index + 1);
  }

  void _playPrevious(int index) {
    /// Stop [index + 1] controller
    _stopControllerAtIndex(index + 1);

    /// Dispose [index + 2] controller
    _disposeControllerAtIndex(index + 2);

    /// Play current video (already initialized)
    _playControllerAtIndex(index);

    /// Initialize [index - 1] controller
    _initializeControllerAtIndex(index - 1);
  }

  Future _initializeControllerAtIndex(int index) async {
    if (state.urls.length > index && index >= 0) {
      /// Create a new [Player]
      late final _player = Player(
        configuration: PlayerConfiguration(
          bufferSize: 64 * 1024 * 1024,
        ),
      );

      /// Create new controller
      final _controller = VideoController(_player);

      /// Add to [controllers] list
      state.controllers[index] = _controller;

      /// Media source
      final _media = Media(state.urls[index]);

      /// Initialize
      await _player
        ..open(_media)
        ..setPlaylistMode(PlaylistMode.single);

      log('[INIT] New player initialized at $index');
    }
  }

  void _playControllerAtIndex(int index) {
    if (state.urls.length > index && index >= 0) {
      /// Get controller at [index]
      final _controller = state.controllers[index]!;

      /// Play controller
      _controller.player.play();

      log('[PLAY] Playing at $index');
    }
  }

  void _stopControllerAtIndex(int index) {
    if (state.urls.length > index && index >= 0) {
      /// Get controller at [index]
      final _controller = state.controllers[index]!;

      /// Pause
      _controller.player.pause();

      /// Reset postiton to beginning
      _controller.player.seek(Duration.zero);

      log('[STOP] Stopped at $index');
    }
  }

  void _disposeControllerAtIndex(int index) {
    if (state.urls.length > index && index >= 0) {
      /// Get controller at [index]
      final _controller = state.controllers[index];

      /// Dispose controller
      _controller?.player.dispose();

      if (_controller != null) {
        state.controllers.remove(_controller);
      }

      log('[DISPOSE] Disposed at $index');
    }
  }

  void _disposeAllControllers() {
    log('[TO IMPLEMENT] It shoud dispose all controllers');
  }
}
