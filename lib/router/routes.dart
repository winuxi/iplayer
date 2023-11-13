
import 'package:flutter/material.dart';
import 'package:iplayer/router/params.dart';

import '../init/splash.dart';
import '../screen/video_list.dart';
import '../screen/video_player.dart';

class AppRoutes {
  static Route generateRoutes(RouteSettings settings){
    if(settings.name == VideoListItem.routeName){
     // PlayerScreenArgs playerScreenArgs = settings as PlayerScreenArgs;
      return MaterialPageRoute(
          builder: (context) => const VideoListItem()
      );
    }
    if(settings.name == VideoPlayerScreen.routeName){
      PlayerScreenArgs playerScreenArgs = settings.arguments as PlayerScreenArgs;
      return MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(args: playerScreenArgs)
      );
    }

    return MaterialPageRoute(builder: (context) => const SplashScreen());
  }
}