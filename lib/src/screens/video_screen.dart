import 'dart:io';
import 'dart:math';

// import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'dart:io';

// import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:status_viewer/src/screens/play_video_screen.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../data/repository/video_repo.dart';
import '../utils/add_manager.dart';
import '../utils/responsive/base_widget.dart';
import '../widgets/common_widgets.dart';

class VideoListView extends StatefulWidget {
  final Directory? directory;

  const VideoListView({Key? key, this.directory}) : super(key: key);

  @override
  _VideoListViewState createState() => _VideoListViewState();
}

class _VideoListViewState extends State<VideoListView>
    with AutomaticKeepAliveClientMixin {
  Future<String?> _getImage(videoPathUrl) async {
    //await Future.delayed(Duration(milliseconds: 500));
    final thumb = await VideoThumbnail.thumbnailFile(video: videoPathUrl);
    return thumb;
  }

  bool _isBottomBannerAdLoaded = false;
  final _inlineAdIndex = 3;
  late BannerAd _bottomBannerAd;
  late final VideoRepository? _videoRepository;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoRepository = VideoRepository();
  }

  //##################### uncomment for Add ########################
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final adManager = Provider.of<AdManager>(context);
    adManager.initialization.then((status) {
      setState(() {
        _createBottomBannerAd(adManager);
        // _createInlineBannerAd(adState);
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bottomBannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_videoRepository!.videoList().isNotEmpty) {
      if (_videoRepository!.videoList().length > 0) {
        return Scaffold(
          body: ResponsiveUi(builder: (context, sizingInformation) {
            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: GridView.builder(
                    itemCount: _videoRepository!.videoList().length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlayStatusVideo(
                                    _videoRepository!.videoList()[index]))),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: FutureBuilder<String?>(
                                future: _getImage(
                                    _videoRepository!.videoList()[index]),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      return Hero(
                                        tag: _videoRepository!
                                            .videoList()[index],
                                        child: Image.file(
                                          File(snapshot.data!),
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                }),

                            //new cod
                          ),
                        ),
                      );
                    },
                  ),
                ),

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
                          height: AdSize.banner.height.toDouble() + 3,
                          width: sizingInformation.localWidgetSize!.width,
                          color: Colors.transparent,
                          child: AdWidget(ad: _bottomBannerAd),
                        )),
                  ),
              ],
            );
          }),
        );
      } else {
        return const Center(
          child: Text(
            'Sorry, No Videos Found.',
            style: TextStyle(fontSize: 18.0),
          ),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
