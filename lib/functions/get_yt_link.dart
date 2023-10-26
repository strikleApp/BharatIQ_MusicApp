import 'package:youtube_explode_dart/youtube_explode_dart.dart';

Future<Uri> ytLink({required String videoId}) async {
  var yt = YoutubeExplode();

  var manifest = await yt.videos.streamsClient.getManifest(videoId);
  var link = manifest.audioOnly.withHighestBitrate();
  return link.url;
}
