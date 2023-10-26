import 'package:flutter/material.dart';
import 'package:musicapp/functions/format.dart';
import 'package:musicapp/functions/get_yt_link.dart';
import 'package:musicapp/provider_function/provider_function_provider.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoCard extends StatefulWidget {
  final Video video;
  const VideoCard({super.key, required this.video});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Please wait...")));
        Map map = Provider.of<ProviderFunctionProvider>(context, listen: false)
            .mapOfIdAndName;
        if (map.keys.toList().contains(widget.video.id.toString())) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Already exist")));
          return;
        }
        final Uri uri = await ytLink(videoId: widget.video.id.value);

        setState(
          () {
            Provider.of<ProviderFunctionProvider>(context, listen: false)
                .addMap(map: {widget.video.id.toString(): widget.video.title});
            Provider.of<ProviderFunctionProvider>(context, listen: false)
                .addAudioToPlaylist(link: uri, id: widget.video.id.toString());
            Provider.of<ProviderFunctionProvider>(context, listen: false)
                .changeIndex(index: 1);
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.video.thumbnails.standardResUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  widget.video.title,
                  textAlign: TextAlign.center,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Author: ${widget.video.author}'),
                    Text(
                        'Views: ${standardizeViewCount(widget.video.engagement.viewCount)}'),
                    Text(
                        'Date: ${formatDateTimeToCustomFormat(widget.video.uploadDate!)}'),
                    Text("Duration: ${formatDuration(widget.video.duration!)}")
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
