import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screen/video_list.dart';

class SplashScreen extends StatefulWidget{
  static const routeName = "/splashScreen";
  const SplashScreen({Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    startTimer();
    super.initState();
  }
  startTimer() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, _openHomeScreen);
  }
  _openHomeScreen(){
   // HomeScreenArgs argument = HomeScreenArgs(userRole: role);
    Navigator.pushNamedAndRemoveUntil(context,
        VideoListItem.routeName, (Route<dynamic> route) => false);
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 100,width: 100,
        child:Image.asset('assets/icon.png')),
      ),
    );
  }

}