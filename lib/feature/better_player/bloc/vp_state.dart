part of 'vp_bloc.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class VPState with _$VPState {
  factory VPState({
    required List<String> urls,
    required Map<int, VideoPlayerController> controllers,
    required int focusedIndex,
    required int reloadCounter,
    required bool isLoading,
  }) = _VPState;

  factory VPState.initial() => VPState(
        focusedIndex: 0,
        reloadCounter: 0,
        isLoading: false,
        urls: [],
        controllers: {},
      );
}
