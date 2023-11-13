import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iplayer/cubit/video_cubit.dart';
import 'package:iplayer/router/params.dart';
import 'package:iplayer/screen/video_player.dart';
import '../cubit/video_state.dart';
import '../models/video_data.dart';
import '../repository/video_repository.dart';
import '../utils/constatnts.dart';
import 'widgets/list_card.dart';
import 'widgets/app_bar.dart';
//import 'package:share_plus/share_plus.dart';
class VideoListItem extends StatefulWidget {
  static const routeName = "/playListScreen";
  //final VideoData videoData;

  const VideoListItem({Key? key}) : super(key: key);

  @override
  State<VideoListItem> createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
   initState() {
    context.read<VideoCubit>().loadVideos();
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  _openShare(){
    //Share.share('check out my website https://example.com');
    //Share.share()
    showSnackBar("Sharing Not Available for moment");
  }
  _openRating(){
    showSnackBar("Rating Not Available for moment");
  }
  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }
  final _appBar = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: VideoAppBar(key: _appBar, title: "Videos",
          appBar: AppBar(), widgets: [
            IconButton(onPressed: _openShare,
                icon: const Icon(Icons.share)),
            IconButton(onPressed: _openRating,
                icon: const Icon(Icons.star_rate))

          ]),
      body: Container(
        child: BlocBuilder<VideoCubit, VideoState>(
          builder: (context, state){
            if(state is VideoLoading){
              return const Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 50,width: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.orange,
                  ),
                ),
              );
            }
            if(state is VideoLoadingFailed){

              return const Padding(
                padding: EdgeInsets.all(19.0),
                child: Center(child: Text("unable to load data")),
              );
            }
            if(state is VideoLoaded){
              return videoHolder(state.videos.videos);
            }
            return const Center(child: Text("No Data Available"));
          }
        ),
      ),

    );
  }

  bool isAppConnected(){
    if (_connectionStatus == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      return true;
    } else if (_connectionStatus == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      return true;
    } else if (_connectionStatus == ConnectivityResult.ethernet) {
      // I am connected to a ethernet network.
      return true;
    } else if (_connectionStatus == ConnectivityResult.vpn) {
      // I am connected to a vpn network.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
      return true;
    } else if (_connectionStatus == ConnectivityResult.bluetooth) {
      // I am connected to a bluetooth.
      return false;
    } else if (_connectionStatus == ConnectivityResult.other) {
      return false;
      // I am connected to a network which is not in the above mentioned networks.
    } else if (_connectionStatus == ConnectivityResult.none) {
      // I am not connected to any network.
      return false;
    }

    return false;
  }
   Widget videoHolder(List<VideoData> videos){
    return videos.isNotEmpty ?
    Column(
      children: [
       Expanded(
          child: ListView.builder(
            //controller: _controller,
              itemCount: videos.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, item) {
                return GestureDetector(
                  onTap: (){
                    if(isAppConnected()){
                      Navigator.pushNamed(
                          context,
                          VideoPlayerScreen.routeName,
                          arguments: PlayerScreenArgs(video: videos[item])
                      ).then((value){
                        // SystemChrome.setPreferredOrientations(
                        //     [DeviceOrientation.portraitUp,
                        //       DeviceOrientation.portraitDown]);
                      });
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Connection Not Available"),
                      ));
                    }

                  },
                  child: ListCard(videoData: videos[item],
                      isConnected: isAppConnected()),
                );
              }),
        )
      ],
    )
        : const Center(child: Text("No Vacancy found"));
  }
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      //developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }
}
