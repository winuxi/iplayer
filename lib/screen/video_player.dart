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
  //AdmobBannerSize? bannerSize;
  //late AdmobInterstitial interstitialAd;
  //late AdmobReward rewardAd;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.args.video.url));
    _controller!.addListener(() {
      setState(() {});
    });
    _controller!.setLooping(true);
    _controller!.initialize().then((_) => setState(() {}));

    //
    // bannerSize = AdmobBannerSize.BANNER;
    //
    // interstitialAd = AdmobInterstitial(
    //   adUnitId: getInterstitialAdUnitId()!,
    //   listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
    //     if (event == AdmobAdEvent.closed) interstitialAd.load();
    //     handleEvent(event, args, 'Interstitial');
    //   },
    // );

    // rewardAd = AdmobReward(
    //   adUnitId: getRewardBasedVideoAdUnitId()!,
    //   listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
    //     if (event == AdmobAdEvent.closed) rewardAd.load();
    //     handleEvent(event, args, 'Reward');
    //   },
    // );

    //interstitialAd.load();
    _showAdAndPlay();
  }

  _showAdAndPlay() {
    // interstitialAd.isLoaded.then((value) => {
    // interstitialAd.show(),
    // _controller!.play()
    // });
    //_interstitiaAd.show();
    loadAd();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  int current = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
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
                // Container(
                //   margin: EdgeInsets.only(bottom: 20.0),
                //   child: AdmobBanner(
                //     adUnitId: getBannerAdUnitId()!,
                //     adSize: bannerSize!,
                //     listener: (AdmobAdEvent event,
                //         Map<String, dynamic>? args) {
                //       handleEvent(event, args, 'Banner');
                //     },
                //     onBannerCreated:
                //         (AdmobBannerController controller) {
                //       // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
                //       // Normally you don't need to worry about disposing this yourself, it's handled.
                //       // If you need direct access to dispose, this is your guy!
                //       // controller.dispose();
                //     },
                //   ),
                // ),
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
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(content),
    //     duration: Duration(milliseconds: 1500),
    //   ),
    // );
  }
  // void _showInterstitialAd() {
  //   if (_interstitialAd == null) {
  //     // Ad is not loaded yet.
  //     return;
  //   }
  //
  //   interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //       ad.dispose();
  //       // Ad dismissed.
  //     },
  //     onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
  //       ad.dispose();
  //       // Ad failed to show.
  //     },
  //   );
  //
  //   interstitialAd.show();
  // }
  //
  // void handleEvent(AdmobAdEvent event, Map<String, dynamic>? args,
  //     String adType) {
  //   switch (event) {
  //     case AdmobAdEvent.loaded:
  //       showSnackBar('New Admob $adType Ad loaded!');
  //       break;
  //     case AdmobAdEvent.opened:
  //       showSnackBar('Admob $adType Ad opened!');
  //       break;
  //     case AdmobAdEvent.closed:
  //       showSnackBar('Admob $adType Ad closed!');
  //       break;
  //     case AdmobAdEvent.failedToLoad:
  //       showSnackBar('Admob $adType failed to load. :(');
  //       break;
  //     case AdmobAdEvent.rewarded:
  //       showDialog(
  //         context: scaffoldState.currentContext!,
  //         builder: (BuildContext context) {
  //           return WillPopScope(
  //             onWillPop: () async {
  //               ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //               return true;
  //             },
  //             child: AlertDialog(
  //               content: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   Text('Reward callback fired. Thanks Andrew!'),
  //                   Text('Type: ${args!['type']}'),
  //                   Text('Amount: ${args['amount']}'),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //       break;
  //     default:
  //   }
  // }
  //

  InterstitialAd? _interstitialAd;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  /// Loads an interstitial ad.
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