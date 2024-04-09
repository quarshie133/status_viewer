import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:status_viewer/src/data/enums/custom_response.dart';
import 'package:status_viewer/src/data/repository/photo_repo.dart';
import 'package:status_viewer/src/data/repository/video_repo.dart';

class VideoBloc {
  final VideoRepository _videoRepository = VideoRepository();

  final _videoListController = BehaviorSubject<List>();
  final _statusController = BehaviorSubject<Response<String>>();

  Stream<List> get videoStream => _videoListController.stream;

  Stream<Response<String>> get statusStream => _statusController.stream;

  StreamSink<List> get parseVideoList => _videoListController.sink;

  StreamSink<Response<String>> get parseStatus => _statusController.sink;

  Future<List> fetchVideos() async {
    try {
      return _videoRepository.videoList();
    } catch (ex) {
      parseStatus.add(Response.error(ex.toString()));
      return [];
    }
  }
}
