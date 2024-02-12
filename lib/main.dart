import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preload_videos/feature/better_player/bloc/bp_bloc.dart';
import 'package:flutter_preload_videos/feature/home/page/home_page.dart';
import 'package:flutter_preload_videos/feature/media_kit/bloc/mk_bloc.dart';
import 'package:flutter_preload_videos/feature/video_player/bloc/vp_bloc.dart';
import 'package:flutter_preload_videos/service/navigation_service.dart';
import 'package:flutter_preload_videos/shared/fps_cubit.dart';
import 'package:flutter_preload_videos/utils/injection.dart';
import 'package:injectable/injectable.dart';
import 'package:media_kit/media_kit.dart';

void main() async {
  /// Ensure that the binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  /// Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();

  /// Initialize the injection
  configureInjection(Environment.prod);

  /// Run the app
  runApp(PreloadVideos());
}

class PreloadVideos extends StatelessWidget {
  final NavigationService _navigationService = getIt<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<VPBloc>()..add(VPEvent.getVideosFromApi()),
        ),
        BlocProvider(
          create: (_) => getIt<BPBloc>()..add(BPEvent.getVideosFromApi()),
        ),
        BlocProvider(
          create: (_) => getIt<MKBloc>()..add(MKEvent.getVideosFromApi()),
        ),
        BlocProvider(
          create: (context) => FPSCubit(),
        ),
      ],
      child: BlocBuilder<FPSCubit, bool>(
        builder: (_, _showPerformanceOverlay) {
          return MaterialApp(
            key: _navigationService.navigationKey,
            debugShowCheckedModeBanner: false,
            showPerformanceOverlay: _showPerformanceOverlay,
            darkTheme: ThemeData.dark(),
            theme: ThemeData(
              colorSchemeSeed: Colors.orange,
            ),
            home: HomePage(),
          );
        },
      ),
    );
  }
}
