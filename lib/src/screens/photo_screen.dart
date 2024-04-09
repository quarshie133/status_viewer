import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:status_viewer/src/bloc/photo_bloc/photo_bloc.dart';
import 'package:status_viewer/src/data/enums/custom_response.dart';
import 'package:status_viewer/src/utils/add_manager.dart';
import 'package:status_viewer/src/utils/responsive/base_widget.dart';
import 'package:status_viewer/src/utils/theme.dart';
import 'package:status_viewer/src/widgets/common_widgets.dart';

import 'package:status_viewer/src/utils/constants.dart';

class PhotoView extends StatefulWidget {
  @override
  PhotoViewState createState() {
    return PhotoViewState();
  }
}

class PhotoViewState extends State<PhotoView>
    with AutomaticKeepAliveClientMixin {
  //##################### uncomment for Add ########################
  final _inlineAdIndex = 3;

  late BannerAd _bottomBannerAd;

  late BannerAd _inlineBannerAd;

  late final AdManager? adManager;

  bool _isBottomBannerAdLoaded = false;
  bool _isInlineBannerAdLoaded = false;

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  final PhotoBloc? _photoBloc = PhotoBloc();

  @override
  void initState() {
    super.initState();
    _photoBloc!.fetchPhotos();
  }

  //##################### uncomment for Add ########################
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // _createUnityFooterBannerAd();
    // _createUnityInlineBannerAd();
    adManager = Provider.of<AdManager>(context);
    adManager!.initialization.then((status) {
      setState(() {
        _createBottomBannerAd(adManager!);
        _createInlineBannerAd(adManager!);
      });
    });
  }

  // void _createUnityFooterBannerAd() {
  //   print("####################   nabs");
  // _unityFooterBannerAd = UnityBannerAd(
  //   size: BannerSize(width: 20, height: 10),
  //   placementId: AdStateUnity.photoFooterBannerAdUnitId,
  //   onLoad: (_) {
  //     setState(() {
  //       print("******************************");
  //       _isBottomBannerAdLoaded = true;
  //     });
  //   },
  //   onFailed: (_, UnityAdsBannerError err, __) {
  //     setState(() {
  //       setState(() {
  //         // _isBottomBannerAdLoaded = false;
  //       });
  //     });
  //   },
  // );
  // }

  // void _createUnityInlineBannerAd() {
  // _unityFooterBannerAd = UnityBannerAd(
  //   size: BannerSize.leaderboard,
  //   placementId: AdStateUnity.photoInlineBannerAdUnitId,
  //   onLoad: (_) {
  //     setState(() {
  //       _isInlineBannerAdLoaded = true;
  //     });
  //   },
  //   onFailed: (_, UnityAdsBannerError err, __) {
  //     setState(() {
  //       setState(() {
  //         _isInlineBannerAdLoaded = false;
  //       });
  //     });
  //   },
  // );
  // }

  // ############  Admob
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

  int _getListViewItemIndex(
      {required int index,
      required int inlineIndex,
      required bool isInlineAddLoaded}) {
    if (index >= inlineIndex && isInlineAddLoaded) {
      return index - 1;
    }
    return index;
  }

  void _createInlineBannerAd(AdManager adManager) {
    _inlineBannerAd = BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: adManager.getInlineBannerAdUnitIdPhoto(),
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) => setState(() {
            _isInlineBannerAdLoaded = true;
          }),
          onAdFailedToLoad: (ad, error) => ad.dispose(),
        ))
      ..load();
  }

  Widget _bannerAdInlineAd() {
    AdManager adM = Provider.of<AdManager>(context);

    final adBanner = BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: adM.getInlineBannerAdUnitIdPhoto(),
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) => setState(() {}),
          onAdFailedToLoad: (ad, error) => ad.dispose(),
        ))
      ..load();

    return AdWidget(ad: adBanner);
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
    // _inlineBannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = max(size.height * .05, 50.0);

    return Scaffold(
        // persistentFooterButtons: [],
        body: ResponsiveUi(builder: (context, sizingInformation) {
      return StreamBuilder<Response>(
          stream: _photoBloc!.statusStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return const Center(child: CircularProgressIndicator());

                case Status.ERROR:
                  return Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: ItemSize.spaceWidth(10)),
                    child: EmptyErrorView(
                        height: height,
                        size: size,
                        scaffoldState: scaffoldState,
                        text: const Text(
                          "Error! \n Please make sure WhatsApp is Installed on your device",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black87, fontSize: 16),
                        )),
                  );
                case Status.COMPLETED:
                  return StreamBuilder<List>(
                    stream: _photoBloc!.photoStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isNotEmpty) {
                          return Stack(
                            children: [
                              StaggeredGridView.countBuilder(
                                  padding: EdgeInsets.fromLTRB(
                                      ItemSize.spaceWidth(4),
                                      ItemSize.spaceHeight(14),
                                      ItemSize.spaceWidth(4),
                                      ItemSize.spaceHeight(14)),
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 3,
                                  mainAxisSpacing: 12,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    if (snapshot.data![index].type !=
                                        "GoogleAd") {
                                      return PhotoGrid(
                                          imgPath: (snapshot.data![index]
                                                  as IMageClass)
                                              .images!);
                                    } else {
                                      return Container(
                                        width: 50,
                                        height: 10,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color:
                                                Theme.of(context).primaryColor,
                                            image: const DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(ConstantImages
                                                    .backgroundTransPath))),
                                        child: _bannerAdInlineAd(),
                                      );
                                    }
                                  }
                                  // {
                                  //   //##################### uncomment for Add ########################
                                  //   if (_isInlineBannerAdLoaded &&
                                  //       index == _inlineAdIndex) {
                                  //     return PhotoGrid(
                                  //       imgPath: '',
                                  //       isAd: true,
                                  //       adWidget: AdWidget(ad: _inlineBannerAd),
                                  //       // adWidget: UnityBannerAd
                                  //       //     AdWidget(ad: _inlineBannerAd)
                                  //     );
                                  //   } else {
                                  //     try {
                                  //       return PhotoGrid(
                                  //           imgPath: snapshot.data![
                                  //               _getListViewItemIndex(
                                  //                   index: index,
                                  //                   inlineIndex: _inlineAdIndex,
                                  //                   isInlineAddLoaded:
                                  //                       _isInlineBannerAdLoaded)]);
                                  //     } catch (e) {
                                  //       return SizedBox();
                                  //     }
                                  //   }
                                  // },
                                  ,
                                  staggeredTileBuilder: (index) {
                                    if (snapshot.data![index].type !=
                                        "GoogleAd") {
                                      return const StaggeredTile.count(1, 1);
                                    } else {
                                      return const StaggeredTile.count(1, 1);
                                    }
                                  }),

                              //################# uncomment for ad session #######
                              if (!_isBottomBannerAdLoaded)
                                const SizedBox(
                                  height: 30,
                                )
                              else
                                Positioned(
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height:
                                            AdSize.banner.height.toDouble() + 3,
                                        width: sizingInformation
                                            .localWidgetSize!.width,
                                        color: Colors.transparent,
                                        child: AdWidget(ad: _bottomBannerAd),
                                      )),
                                ),
                            ],
                          );
                        } else {
                          return Center(
                              // heightFactor: 13,
                              child: emptyListNotice(
                                  context: context,
                                  emptyListText: "No images available."));
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          });
    }));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
