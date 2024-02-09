// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_preload_videos/feature/better_player/bloc/bp_bloc.dart'
    as _i3;
import 'package:flutter_preload_videos/feature/media_kit/bloc/mk_bloc.dart'
    as _i4;
import 'package:flutter_preload_videos/feature/video_player/bloc/vp_bloc.dart'
    as _i6;
import 'package:flutter_preload_videos/service/navigation_service.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

const String _prod = 'prod';

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.BPBloc>(
      () => _i3.BPBloc(),
      registerFor: {_prod},
    );
    gh.factory<_i4.MKBloc>(
      () => _i4.MKBloc(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i5.NavigationService>(() => _i5.NavigationService());
    gh.factory<_i6.VPBloc>(
      () => _i6.VPBloc(),
      registerFor: {_prod},
    );
    return this;
  }
}
