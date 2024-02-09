part of 'mk_bloc.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class MKState with _$MKState {
  factory MKState({
    required List<String> urls,
    required Map<int, VideoController> controllers,
    required int focusedIndex,
    required int reloadCounter,
    required bool isLoading,
  }) = _MKState;

  factory MKState.initial() => MKState(
        focusedIndex: 0,
        reloadCounter: 0,
        isLoading: false,
        urls: [],
        controllers: {},
      );
}
