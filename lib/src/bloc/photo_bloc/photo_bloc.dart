import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:status_viewer/src/data/enums/custom_response.dart';
import 'package:status_viewer/src/data/repository/photo_repo.dart';

class PhotoBloc {
  final PhotoRepository _photoRepository = PhotoRepository();
  final _list = <IMageClass>[];

  final _photoListController = BehaviorSubject<List>();
  final _statusController = BehaviorSubject<Response<String>>();

  Stream<List> get photoStream => _photoListController.stream;

  Stream<Response<String>> get statusStream => _statusController.stream;

  StreamSink<List> get parsePhotoList => _photoListController.sink;

  StreamSink<Response<String>> get parseStatus => _statusController.sink;

  fetchPhotos() {
    try {
      parseStatus.add(Response.loading('loading'));
      _photoRepository.imageList();

      for (int i = 0; i < _photoRepository.imageList().length; i++) {
        var image = IMageClass();

        if (i != 0) {
          if (i % 8 == 5) {
            image.type = "GoogleAd";
          } else {
            image.type = "";
            image.images = _photoRepository.imageList()[i];
          }
          _list.add(image);
        } else {
          image.type = "";
          image.images = _photoRepository.imageList()[i];
          _list.add(image);
        }
      }

      parsePhotoList.add(_list);
      parseStatus.add(Response.completed('completed'));
    } catch (ex) {
      parseStatus.add(Response.error(ex.toString()));
    }
  }
}

class IMageClass {
  String? images;
  String? type;
}
