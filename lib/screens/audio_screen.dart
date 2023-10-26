import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp/provider_function/provider_function_provider.dart';
import 'package:provider/provider.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  AudioPlayerScreenState createState() => AudioPlayerScreenState();
}

class AudioPlayerScreenState extends State<AudioPlayerScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  int currentIndex = 0;
  bool isPlaying = false;
  late AnimationController _animationController;
  Duration _sliderValue = Duration.zero;
  String? _currentPlaying;
  Duration _durationOfSong = Duration.zero;

  @override
  void initState() {
    _player.sequenceStateStream.listen((event) {
      if (event != null) {
        if (event.currentSource != null) {
          _currentPlaying = event.currentSource!.tag;
        }
      }
    });
    _player.positionStream.listen((event) {
      setState(() {
        _sliderValue = event;
      });
    });
    _player.durationStream.listen((event) {
      if (event != null) {
        setState(() {
          _durationOfSong = event;
        });
      }
    });
    _player.setAudioSource(
        Provider.of<ProviderFunctionProvider>(context, listen: false).playlist,
        initialIndex: 0,
        initialPosition: Duration.zero);
    _player.playerStateStream.listen(
      (event) {
        if (event.processingState == ProcessingState.buffering) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Buffering..."),
            ),
          );
        }
      },
    );
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> mapOfIdAndName =
        Provider.of<ProviderFunctionProvider>(context).mapOfIdAndName;
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: mapOfIdAndName.keys.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    leading: Text(
                      (index + 1).toString(),
                    ),
                    title: Text(mapOfIdAndName.values.toList()[index]),
                    tileColor:
                        _currentPlaying == mapOfIdAndName.keys.toList()[index]
                            ? Theme.of(context).colorScheme.primary
                            : null,
                    onTap: () async {
                      await _player.seek(Duration.zero, index: index);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 8, top: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.fast_rewind,
                        size: 30,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      onPressed: () async {
                        await _player.seekToPrevious();
                        setState(() {});
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: BoxShape.circle),
                        child: InkWell(
                          onTap: () {
                            if (!_player.playing) {
                              _animationController.forward();
                              _player.play();
                            } else {
                              _animationController.reverse();
                              _player.pause();
                            }
                          },
                          child: AnimatedIcon(
                              icon: AnimatedIcons.play_pause,
                              color: Theme.of(context).colorScheme.tertiary,
                              size: 60,
                              progress: _animationController),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.fast_forward,
                        size: 30,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      onPressed: () async {
                        await _player.seekToNext();
                        setState(() {});
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Slider(
                      activeColor: Theme.of(context).colorScheme.secondary,
                      value: _sliderValue.inSeconds.toDouble(),
                      max: _durationOfSong.inSeconds.toDouble(),
                      onChanged: (value) {
                        _player.seek(Duration(seconds: value.toInt()));
                      }),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
