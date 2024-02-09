part of 'bp_bloc.dart';

@freezed
class BPEvent with _$BPEvent {
  const factory BPEvent.getVideosFromApi() = _GetVideosFromApi;
  const factory BPEvent.setLoading() = _SetLoading;
  const factory BPEvent.updateUrls(
    List<String> urls,
  ) = _UpdateUrls;
  const factory BPEvent.onVideoIndexChanged(
    int index,
  ) = _OnVideoIndexChanged;
  const factory BPEvent.disposeAllControllers() = _DisposeAllControllers;
}
