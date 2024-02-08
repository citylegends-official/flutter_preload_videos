part of 'vp_bloc.dart';

@freezed
class VPEvent with _$VPEvent {
  const factory VPEvent.getVideosFromApi() = _GetVideosFromApi;
  const factory VPEvent.setLoading() = _SetLoading;
  const factory VPEvent.updateUrls(
    List<String> urls,
  ) = _UpdateUrls;
  const factory VPEvent.onVideoIndexChanged(
    int index,
  ) = _OnVideoIndexChanged;
  const factory VPEvent.disposeAllControllers() = _DisposeAllControllers;
}
