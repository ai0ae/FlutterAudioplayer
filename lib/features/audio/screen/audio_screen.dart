import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/common/utils/translation.dart';

import 'package:flutter_application_audioplayer/common/widgets/custom_widget.dart';
import 'package:flutter_application_audioplayer/constansts/const.dart';
import 'package:flutter_application_audioplayer/features/audio/widgets/audio_bar.dart';
import 'package:flutter_application_audioplayer/features/home/screen/search_screen.dart';
import 'package:flutter_application_audioplayer/models/audio.dart';
import 'package:flutter_application_audioplayer/providers/favorites_provider.dart';
import 'package:provider/provider.dart';

class AudioScreen extends StatelessWidget {
  final List<Audio> queue;
  int index;
  static const routeName = '/audio-page';
  final Audio audio;
  AudioScreen({
    //Showcase the ability to send and receive data accurately and efficiently.
    Key? key,
    required this.audio,
    required this.queue, this.index = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(SearchScreen.routeName),
            icon: const Icon(
              Icons.search,
              size: 40,
            ),
          )
        ],
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 40,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 10,
          ),
          AudioBar(
            queue: queue,
            index: index,
            audio: audio,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            child: ActivivtyBar(id: audio.id),
          ),
        ],
      ),
    );
  }
}

class ActivivtyBar extends StatelessWidget {
  final String id;
  const ActivivtyBar({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favs = Provider.of<FavoritesProvider>(context,
        listen:
            true); // Utilize Provider to handle the flow of data between different widgets and screens.
    return FutureBuilder(
        future: favs.isFav(id),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            return Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).dialogBackgroundColor,
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {},
                      iconSize: 35,
                      icon: Icon(Icons.heart_broken_sharp)),
                  IconButton(
                      onPressed: () async {
                        bool check = snapshot.data!;
                        if (check) {
                          favs.removeFromFavs(id);
                        } else {
                          favs.addFavs(id);
                        }
                      },
                      iconSize: 35,
                      icon: Icon(snapshot.data!
                          ? Icons.star
                          : Icons.star_border_outlined)),
                  IconButton(
                      onPressed: () {}, iconSize: 35, icon: Icon(Icons.share))
                ],
              ),
            );
          }
        });
  }
}
