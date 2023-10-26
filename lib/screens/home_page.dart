import 'package:flutter/material.dart';
import 'package:musicapp/provider_function/provider_function_provider.dart';
import 'package:musicapp/screens/audio_screen.dart';
import 'package:musicapp/screens/video_card.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    int currentIndex =
        Provider.of<ProviderFunctionProvider>(context).currentNavbarIndex;
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          VideoScreen(),
          AudioPlayerScreen(),
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).colorScheme.tertiary,
        selectedItemColor: Theme.of(context).colorScheme.tertiary,
        currentIndex: currentIndex,
        onTap: (index) {
          Provider.of<ProviderFunctionProvider>(context, listen: false)
              .changeIndex(index: index);
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.music_note_rounded),
            title: const Text("Audio"),
          ),
        ],
      ),
    );
  }
}

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final TextEditingController _searchTextController = TextEditingController();

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    VideoSearchList searchList =
        Provider.of<ProviderFunctionProvider>(context).searchList;
    return AbsorbPointer(
      absorbing: _isLoading,
      child: Stack(
        children: [
          ListView.builder(
            itemCount: searchList.length,
            itemBuilder: (context, index) {
              return VideoCard(
                video: searchList[index],
              );
            },
          ),
          SafeArea(
            child: SearchBarAnimation(
              enableKeyboardFocus: true,
              isSearchBoxOnRightSide: true,
              onEditingComplete: () {
                if (_searchTextController.text.trim().isNotEmpty) {
                  setState(() {
                    _isLoading = true;
                  });
                  Provider.of<ProviderFunctionProvider>(context, listen: false)
                      .fillVideoSearchList(
                          search: _searchTextController.text.trim());
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              buttonColour: Theme.of(context).primaryColor,
              hintText: "Search song",
              textEditingController: _searchTextController,
              isOriginalAnimation: true,
              trailingWidget: InkWell(
                onTap: () async {
                  if (_searchTextController.text.trim().isNotEmpty) {
                    setState(() {
                      _isLoading = true;
                    });
                    FocusScope.of(context).unfocus();
                    await Provider.of<ProviderFunctionProvider>(context,
                            listen: false)
                        .fillVideoSearchList(
                            search: _searchTextController.text.trim());

                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                child: const Icon(
                  Icons.search_rounded,
                ),
              ),
              secondaryButtonWidget: const Icon(Icons.close),
              buttonWidget: const Icon(
                Icons.search_rounded,
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            )
        ],
      ),
    );
  }
}
