part of 'bp_bloc.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class BPState with _$BPState {
  factory BPState({
    required List<String> urls,
    required Map<int, BetterPlayerController> controllers,
    required int focusedIndex,
    required int reloadCounter,
    required bool isLoading,
  }) = _BPState;

  factory BPState.initial() => BPState(
        focusedIndex: 0,
        reloadCounter: 0,
        isLoading: false,
        urls: [],
        controllers: {},
      );
}
