import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

Stream<String?> getImage(videoPathUrl) async* {
  String? fileName = await VideoThumbnail.thumbnailFile(
    video: videoPathUrl,
    thumbnailPath: (await getTemporaryDirectory()).path,
    imageFormat: ImageFormat.PNG,
    quality: 10,
  );
  yield fileName;
}
