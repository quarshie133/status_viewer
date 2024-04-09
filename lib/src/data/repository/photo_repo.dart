import 'dart:io';

import 'package:status_viewer/src/utils/constants.dart';

class PhotoRepository {
  final Directory _photoDir1 = Directory(imgDirectoryUrl);
  final Directory _photoDir2 = Directory(imgDirectoryUrl11);

  imageList() {
    List data1 = [], data2 = [];

    try {
      data1 = _photoDir1
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith(".jpg"))
          .toList(growable: false);
    } catch (ex) {}

    try {
      data2 = _photoDir2
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith(".jpg"))
          .toList(growable: false);
    } catch (ex) {}

    return <dynamic>{...data1, ...data2}.toList();
  }
}
