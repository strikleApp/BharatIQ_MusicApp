import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class ProviderFunctionProvider extends ChangeNotifier {
  late VideoSearchList searchList;
  ConcatenatingAudioSource playlist =
      ConcatenatingAudioSource(useLazyPreparation: true, children: []);
  int currentNavbarIndex = 0;

  Map<String, dynamic> mapOfIdAndName = {};

  void addMap({required Map<String, dynamic> map}) {
    mapOfIdAndName.addAll(map);

    notifyListeners();
  }

  void changeIndex ({required int index}){
    currentNavbarIndex = index;
    notifyListeners();
  }

  void addAudioToPlaylist({required Uri link , required String id}) {
    AudioSource source = AudioSource.uri(link ,tag: id);
    playlist.add(source);
    notifyListeners();
  }

  Future<void> fillVideoSearchList({required String search}) async {
    try {
      YoutubeExplode yt = YoutubeExplode();
      VideoSearchList list =
          await yt.search(search, filter: const SearchFilter('Popularity'));
      list.removeWhere((p0) => p0.isLive == true);
      searchList = list;
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}
