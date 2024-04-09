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
import 'package:status_viewer/src/utils/theme.dart';
import 'package:status_viewer/src/widgets/common_widgets.dart';



import '../utils/add_manager.dart';
import '../utils/responsive/base_widget.dart';

const int maxFailedLoadAttempts = 3;

class ViewPhoto extends StatefulWidget {
  final String imgPath;

  ViewPhoto({required this.imgPath});

  @override
  _ViewPhotoState createState() => _ViewPhotoState();
}

class _ViewPhotoState extends State<ViewPhoto> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  int _interstitialLoadAttempts = 0;
  bool _isBottomBannerAdLoaded = false;

  late BannerAd _bottomBannerAd;
  InterstitialAd? _interstitialAd;

  //
  AdManager? _adManager;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adManager = Provider.of<AdManager>(context, listen: false);
    _createInterstitialAd(_adManager!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _interstitialAd?.dispose();
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
      });
    });
  }

  void _createInterstitialAd(AdManager adManager) {
    InterstitialAd.load(
        adUnitId: adManager.getInterstitialAdUnitIdPhoto(),
        request: const AdRequest(),
        adLoadCallback:
            InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
        }, onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_interstitialLoadAttempts >= maxFailedLoadAttempts) {
            _createInterstitialAd(adManager);
          }
        }));
  }

  void _showInterstitialAd(AdManager adManager) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _createInterstitialAd(adManager);
      }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError er) {
        ad.dispose();
        _createInterstitialAd(adManager);
      });
      _interstitialAd!.show();
    }
  }

  final LinearGradient backgroundGradient = const LinearGradient(
    colors: [
      Color(0x00000000),
      Color(0x00333333),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  void _onLoading(bool t, String str, BuildContext context) {
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

  void _createBottomBannerAd(AdManager adManager) {
    _bottomBannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adManager.getBannerAdUnitIdPhoto(),
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) => setState(() {
            _isBottomBannerAdLoaded = true;
          }),
          onAdFailedToLoad: (ad, error) => ad.dispose(),
        ))
      ..load();
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
                if (widget.imgPath != null) {
                  Share.shareXFiles([XFile(widget.imgPath)]);
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
                _onLoading(true, "", context);

                await Future.delayed(const Duration(seconds: 2))
                    .then((value) async {
                  await GallerySaver.saveImage(widget.imgPath).then((value) {
                    _showInterstitialAd(_adManager!);
                    // UnityAds.showVideoAd(placementId: 'Interstitial_Android');
                    _onLoading(false, "", context);
                  }).onError((error, stackTrace) {
                    _onLoading(
                        false,
                        "If Image is not available in gallary\n\nYou can find all images at downloads",
                        context);
                  });
                });
              }),
        ],
        leading: IconButton(
          color: Colors.indigo,
          iconSize: ItemSize.fontSize(24),
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
                child: Hero(
                  tag: widget.imgPath,
                  child: Image.file(
                    File(widget.imgPath),
                    fit: BoxFit.cover,
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
      }),
      // floatingActionButton: FloatingActionButton(
      //     backgroundColor: Theme.of(context).primaryColor,
      //     child: Icon(
      //       Icons.file_download,
      //       color: Colors.white,
      //     ),
      //     onPressed: () async {}),
    );
  }
}
