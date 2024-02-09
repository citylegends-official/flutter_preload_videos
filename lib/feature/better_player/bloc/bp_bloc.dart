import 'dart:async';
import 'dart:developer';

import 'package:better_player/better_player.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_preload_videos/service/api_service.dart';
import 'package:flutter_preload_videos/core/constants.dart';
import 'package:flutter_preload_videos/utils/isolate.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'bp_bloc.freezed.dart';
part 'bp_event.dart';
part 'bp_state.dart';

@injectable
@prod
class BPBloc extends Bloc<BPEvent, BPState> {
  BPBloc() : super(BPState.initial()) {
    on(_mapEventToState);
  }

  @override
  Future<void> close() {
    log('[DISPOSE] Disposing the BP Bloc instance');
    return super.close();
  }

  void _mapEventToState(BPEvent event, Emitter<BPState> emit) async {
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
                BPEvent.setLoading(),
              ),
            updateUrls: (urls) => this
              ..add(
                BPEvent.updateUrls(urls),
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
      /// Create new data source
      final _dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        state.urls[index],
      );

      /// Create new controller
      final _controller = BetterPlayerController(
        BetterPlayerConfiguration(
          autoPlay: true,
          looping: true,
          expandToFill: true,
          fit: BoxFit.cover,
          aspectRatio: 9 / 16,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            showControls: false,
          ),
        ),
      );

      /// Add to [controllers] list
      state.controllers[index] = _controller;

      /// Initialize
      await _controller.setupDataSource(_dataSource);

      log('[INIT] New player initialized at $index');
    }
  }

  void _playControllerAtIndex(int index) {
    if (state.urls.length > index && index >= 0) {
      /// Get controller at [index]
      final _controller = state.controllers[index]!;

      /// Play controller
      _controller.play();

      log('[PLAY] Playing at $index');
    }
  }

  void _stopControllerAtIndex(int index) {
    if (state.urls.length > index && index >= 0) {
      /// Get controller at [index]
      final _controller = state.controllers[index]!;

      /// Pause
      _controller.pause();

      /// Reset postiton to beginning
      _controller.seekTo(Duration.zero);

      log('[STOP] Stopped at $index');
    }
  }

  void _disposeControllerAtIndex(int index) {
    if (state.urls.length > index && index >= 0) {
      /// Get controller at [index]
      final _controller = state.controllers[index];

      /// Dispose controller
      _controller?.dispose();

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
