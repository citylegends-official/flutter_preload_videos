import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preload_videos/feature/video_player/bloc/vp_bloc.dart';
import 'package:flutter_preload_videos/feature/home/page/home_page.dart';
import 'package:flutter_preload_videos/service/navigation_service.dart';
import 'package:flutter_preload_videos/utils/injection.dart';
import 'package:injectable/injectable.dart';

void main() async {
  /// Ensure that the binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize the injection
  configureInjection(Environment.prod);

  /// Run the app
  runApp(PreloadVideos());
}

class PreloadVideos extends StatelessWidget {
  final NavigationService _navigationService = getIt<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VPBloc>()
        ..add(
          VPEvent.getVideosFromApi(),
        ),
      child: MaterialApp(
        key: _navigationService.navigationKey,
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark(),
        theme: ThemeData.light(),
        home: HomePage(),
      ),
    );
  }
}
