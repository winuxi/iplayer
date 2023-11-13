import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iplayer/router/params.dart';
import 'package:video_player/video_player.dart';
//import 'package:admob_flutter/admob_flutter.dart';
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
class VideoPlayerScreen extends StatefulWidget {
  static const routeName = "/playerScreen";
  final PlayerScreenArgs args;

  const VideoPlayerScreen({Key? key, required this.args}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.args.video.url));
    _controller!.addListener(() {
      setState(() {});
    });
    _controller!.setLooping(true);
    _controller!.initialize().then((_) => setState(() {}));


    _showAdAndPlay();
  }

  _showAdAndPlay() {
    loadAd();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller?.dispose();
    super.dispose();
  }

  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                VideoPlayer(_controller!),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Theme(
                        data: Theme.of(context)
                            .copyWith(canvasColor: Colors.transparent),
                        child: BottomNavigationBar(
                          currentIndex: current,
                          onTap: (index) {
                            if (index == 0) {
                              Navigator.pop(context);
                            }
                            if (index == 1) {
                              setState(() {
                                current = 1;
                              });
                              _togglePlayPause();
                            }
                          },
                          items: [
                            const BottomNavigationBarItem(
                                icon: Icon(Icons.arrow_back), label: 'Back'),
                            BottomNavigationBarItem(
                              icon: Icon(_controller!.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow),
                              label: 'Play/Pause',
                            ),
                          ],
                        ))),

              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _togglePlayPause(),
      //   child: Icon(_controller!.value.isPlaying
      //       ? Icons.pause
      //       : Icons.play_arrow),
      // ),
    );
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }


  String? getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return null;
  }

  String? getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
    return null;
  }

  String? getRewardBasedVideoAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
    return null;
  }

  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  InterstitialAd? _interstitialAd;

  void loadAd() {
    InterstitialAd.load(
        adUnitId: getInterstitialAdUnitId()!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                  _controller!.play();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
            _interstitialAd!.show();

          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

}