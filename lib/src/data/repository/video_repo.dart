import 'dart:io';
import 'package:status_viewer/src/utils/constants.dart';

class VideoRepository {
  final Directory _videoDir1 = Directory(videoDirectoryUrl);
  final Directory _videoDir2 = Directory(videoDirectoryUrl11);

  videoList() {
    List data1 = [], data2 = [];

    try {
      data1 = _videoDir1
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith(".mp4"))
          .toList(growable: false);
    } catch (ex) {}

    try {
      data2 = _videoDir2
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith(".mp4"))
          .toList(growable: false);
    } catch (ex) {}

    //################### uncomment this for Ad ######################
    // List data = <dynamic>{...data1, ...data2}.toList();
    // int rand = ([4, 5, 6, 7].toList()..shuffle()).first;
    //
    // // adding slots for interstitial Ads
    // if (data.length > 5) {
    //   for (int i = 1; i < data.length; i++) {
    //     if (i % rand == 0) {
    //       data.insert(i, "AD");
    //     }
    //   }
    // }

    return <dynamic>{...data1, ...data2}.toList();
  }
}
