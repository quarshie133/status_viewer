import 'dart:io';

// import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:status_viewer/src/components/video_controller.dart';
import 'package:status_viewer/src/utils/theme.dart';
import 'package:status_viewer/src/widgets/admob_widgets.dart';
import 'package:status_viewer/src/widgets/common_widgets.dart';
import 'package:video_player/video_player.dart';

import '../utils/add_manager.dart';
import '../utils/responsive/base_widget.dart';

const int maxFailedLoadAttempts = 3;

class PlayStatusVideo extends StatefulWidget {
  final String videoFile;

  PlayStatusVideo(this.videoFile);

  @override
  _PlayStatusVideoState createState() => _PlayStatusVideoState();
}

class _PlayStatusVideoState extends State<PlayStatusVideo> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  int _interstitialLoadAttempts = 0;
  InterstitialAd? _interstitialAd;
  late final AdManager? _adManager;
  late BannerAd _bottomBannerAd;

  VideoPlayerController? _videoPlayerController;

  bool _isBottomBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _adManager = Provider.of<AdManager>(context, listen: false);
    _videoPlayerController = VideoPlayerController.file(File(widget.videoFile));
  }

  //##################### uncomment for Add ########################
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // _createUnityFooterBannerAd();
    // _createUnityInlineBannerAd();
    _adManager!.initialization.then((status) {
      setState(() {
        _createBottomBannerAd(_adManager!);
        _createInterstitialAd(_adManager!);
      });
    });
  }

  void _createBottomBannerAd(AdManager adManager) {
    _bottomBannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adManager.getBannerAdUnitIdVideo(),
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) => setState(() {
            _isBottomBannerAdLoaded = true;
          }),
          onAdFailedToLoad: (ad, error) => ad.dispose(),
        ))
      ..load();
  }

  void _createInterstitialAd(AdManager adManager) {
    InterstitialAd.load(
        adUnitId: adManager.getInterstitialAdUnitIdVideo(),
        request: const AdRequest(),
        adLoadCallback:
            InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
        }, onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_interstitialLoadAttempts >= maxFailedLoadAttempts) {
            _createInterstitialAd(_adManager!);
          }
        }));
  }

  //
  void _showInterstitialAd(AdManager adManager) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _createInterstitialAd(_adManager!);
      }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError er) {
        ad.dispose();
        _createInterstitialAd(_adManager!);
      });
      _interstitialAd!.show();
    }
  }

  void dispose() {
    super.dispose();
    _videoPlayerController!.dispose();
  }

  void _onLoading(bool t, String str) {
    if (t) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: [
                Center(
                  child: Container(
                      padding: EdgeInsets.all(ItemSize.radius(10)),
                      child: const CircularProgressIndicator()),
                ),
              ],
            );
          });
    } else {
      Navigator.pop(context);
      successSnackBar(
          context: context, message: "Download successful: Saved to Gallery");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.share_sharp,
                  size: ItemSize.fontSize(25),
                  color: Colors.black87,
                ),
                onPressed: () async {
                  if (widget.videoFile != null) {
                    Share.shareXFiles([XFile(widget.videoFile)]);
                    // UnityAds.showVideoAd(placementId: 'Interstitial_Android');
                    _showInterstitialAd(_adManager!);
                  } else {
                    errorSnackBar(context: context, message: "File not found");
                  }
                }),
            IconButton(
                icon: Icon(
                  Icons.file_download,
                  size: ItemSize.fontSize(28),
                  color: Colors.black87,
                ),
                onPressed: () async {
                  _onLoading(true, "");
                  await Future.delayed(const Duration(seconds: 2))
                      .then((value) async {
                    await GallerySaver.saveVideo(widget.videoFile)
                        .then((value) {
                      // UnityAds.showVideoAd(placementId: 'Interstitial_Android');
                      _showInterstitialAd(_adManager!);
                      _onLoading(false, "");
                    }).onError((error, stackTrace) {
                      _onLoading(
                        false,
                        "If Video not available in gallary\n\nYou can find all videos at downloads",
                      );
                    });
                  });
                  // if (await interstitialAd.isLoaded) {
                  //   interstitialAd.show();
                  // } else {}
                })
          ],
          leading: IconButton(
            color: Colors.indigo,
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: ResponsiveUi(builder: (context, sizingInformation) {
          return SizedBox.expand(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: StatusVideo(
                      videoPlayerController: _videoPlayerController!
                      //  VideoPlayerController.file(File(widget.videoFile)),
                      ,
                      looping: false,
                      videoSrc: widget.videoFile,
                    ),
                  ),
                ),
                if (!_isBottomBannerAdLoaded)
                  const SizedBox(
                    height: 30,
                  )
                else
                  Positioned(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: AdSize.banner.height.toDouble() + 3,
                          width: sizingInformation.localWidgetSize!.width,
                          color: Colors.transparent,
                          child: AdWidget(ad: _bottomBannerAd),
                        )),
                  ),
              ],
            ),
          );
        }));
  }
}
