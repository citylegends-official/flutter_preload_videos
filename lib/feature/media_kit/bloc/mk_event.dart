part of 'mk_bloc.dart';

@freezed
class MKEvent with _$MKEvent {
  const factory MKEvent.getVideosFromApi() = _GetVideosFromApi;
  const factory MKEvent.setLoading() = _SetLoading;
  const factory MKEvent.updateUrls(
    List<String> urls,
  ) = _UpdateUrls;
  const factory MKEvent.onVideoIndexChanged(
    int index,
  ) = _OnVideoIndexChanged;
  const factory MKEvent.disposeAllControllers() = _DisposeAllControllers;
}
