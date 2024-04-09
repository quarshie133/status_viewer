import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:status_viewer/src/screens/play_video_screen.dart';
import 'package:status_viewer/src/screens/view_photo_screen.dart';
import 'package:status_viewer/src/utils/theme.dart';
import 'package:status_viewer/src/utils/utility.dart';

Widget emptyListNotice(
    {required BuildContext context, required String emptyListText}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          emptyListText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff707070),
            fontWeight: FontWeight.normal,
            fontFamily: Theme.of(context).textTheme.headline1!.fontFamily,
            fontSize: ItemSize.fontSize(16),
          ),
        ),
      ],
    ),
  );
}

class EmptyErrorView extends StatelessWidget {
  final size;
  final GlobalKey<ScaffoldState>? scaffoldState;
  final height;
  final Text text;

  const EmptyErrorView(
      {Key? key,
      this.size,
      this.height,
      this.scaffoldState,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: size.width,
            height: height,
            // child: createBannerAdaptiveAd(
            //     size: size,
            //     scaffoldState: scaffoldState,
            //     adId: AdManager.getBannerAdUnitIdPhoto()),
          ),
          Container(
            padding: EdgeInsets.only(top: size.height / 4),
            child: text,
          ),
        ],
      ),
    );
  }
}

class VideoGrid extends StatelessWidget {
  final String imgPath;
  final Widget? adWidget;
  final bool isAd;

  const VideoGrid(
      {Key? key, required this.imgPath, this.isAd = false, this.adWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isAd
        ? adWidget!
        : Container(
            padding: EdgeInsets.all(ItemSize.radius(10)),
            child: StreamBuilder<String?>(
                stream: getImage(imgPath),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Column(children: [
                        Stack(
                          children: <Widget>[
                            Center(
                              child: Container(
                                constraints: BoxConstraints(
                                  minHeight: ItemSize.spaceHeight(100),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(
                                        ItemSize.radius(12))),
                                height: ItemSize.spaceHeight(130),
                                width: ItemSize.spaceWidth(150),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      ItemSize.radius(12)),
                                  child: Image.file(
                                    File(snapshot.data!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.black87.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(
                                      ItemSize.radius(12))),
                              height: ItemSize.spaceHeight(130),
                              width: ItemSize.spaceWidth(150),
                            ),
                            Center(
                              heightFactor: 2.5,
                              child: MaterialButton(
                                elevation: 0.0,
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PlayStatusVideo(imgPath)));
                                },
                                color: Colors.black87,
                                textColor: Colors.white,
                                child: Icon(
                                  Icons.play_arrow,
                                  size: ItemSize.fontSize(50),
                                  color: Colors.white70,
                                ),
                                padding: EdgeInsets.all(ItemSize.radius(10)),
                                shape: const CircleBorder(),
                              ),
                            ),
                          ],
                        )
                      ]);
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  } else {
                    return Hero(
                        tag: imgPath,
                        child: SpinKitRipple(
                          color: Theme.of(context).primaryColor,
                          size: 50.0,
                        ));
                  }
                }),
          );
  }
}

class PhotoGrid extends StatelessWidget {
  final String imgPath;
  final Widget? adWidget;
  final bool isAd;

  const PhotoGrid({required this.imgPath, this.isAd = false, this.adWidget});

  @override
  Widget build(BuildContext context) {
    return isAd
        ? adWidget!
        : Container(
            decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: InkWell(
              onTap: () {
                try {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewPhoto(
                              imgPath: imgPath,
                            )),
                  );
                } catch (e) {}
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Hero(
                  tag: imgPath,
                  child: Image.file(
                    File(imgPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
  }
}

errorSnackBar({required BuildContext context, String? message}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 0.0,
      content: Text(
        '$message',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            fontFamily: Theme.of(context).textTheme.headline1!.fontFamily),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: const Color(0xfff9691c),
    ),
  );
}

successSnackBar(
    {Key? key, required BuildContext context, required String message}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      key: key,
      elevation: 0.0,
      content: Text(
        '$message',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            fontFamily: Theme.of(context).textTheme.headline1!.fontFamily),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
    ),
  );
}

showSnackBar({required BuildContext context, required String content}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      duration: const Duration(milliseconds: 1500),
    ),
  );
}

dialogDownload({required BuildContext context, required String str}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(ItemSize.radius(8)),
          child: SimpleDialog(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(ItemSize.radius(2)),
                  child: Column(
                    children: [
                      Text(
                        "$str",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: ItemSize.fontSize(16),
                            fontWeight: FontWeight.normal),
                      ),
                      MaterialButton(
                        child: const Text("Close"),
                        color: Colors.teal,
                        textColor: Colors.white,
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
