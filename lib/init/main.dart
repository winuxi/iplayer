
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iplayer/cubit/video_cubit.dart';
import 'package:iplayer/router/routes.dart';
import 'package:iplayer/utils/constatnts.dart';

import '../repository/video_repository.dart';
import 'package:admob_flutter/admob_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  VideoRepository videoRepository = VideoRepository();
  String color = await videoRepository.getBackgroundColor();
  runApp(MyApp(videoRepository: videoRepository, theme: color));
}

class MyApp extends StatelessWidget {
  final VideoRepository videoRepository;
  final String theme;
   const MyApp({super.key, required this.videoRepository, required this.theme});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => VideoCubit(videoRepository: videoRepository))
    ], child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Player',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: hexToColor(theme),
          //background: hexToColor(theme)
        ),
        useMaterial3: true,
      ),
      onGenerateRoute: AppRoutes.generateRoutes,
    ));
  }
}

