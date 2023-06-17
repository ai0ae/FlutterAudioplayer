import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/common/widgets/custom_widget.dart';
import 'package:flutter_application_audioplayer/features/home/service/home_service.dart';
import 'package:flutter_application_audioplayer/models/audio.dart';

class AudioBar extends StatefulWidget {
  final Audio audio;
  final List<Audio> queue;
  final int index;
  AudioBar(
      {super.key,
      required this.audio,
      required this.queue,
      required this.index});

  @override
  State<AudioBar> createState() => _AudioBarState();
}

class _AudioBarState extends State<AudioBar> {
  late Audio currentAudio;
  late int index;
  int maxduration = 100;

  int currentpos = 0;

  String currentpostlabel = "00:00";
  String maxDurationLabel = "00:00";
  bool isplaying = false;

  bool audioplayed = false;
  List<StreamSubscription> streams = [];

  late AudioPlayer player;

  @override
  void initState() {
    index = widget.index;
    currentAudio = widget.audio;
    player = AudioPlayer();
    Future.delayed(Duration.zero, () async {
      streams.add(player.onDurationChanged.listen((Duration d) {
        //get the duration of audio
        maxduration = d.inMilliseconds;
        int shours = Duration(milliseconds: maxduration).inHours;
        int sminutes = Duration(milliseconds: maxduration).inMinutes;
        int sseconds = Duration(milliseconds: maxduration).inSeconds;

        int rhours = shours;
        int rminutes = sminutes - (shours * 60);
        int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);
        maxDurationLabel = "$rhours:$rminutes:$rseconds";

        setState(() {});
      }));

      streams.add(player.onPositionChanged.listen((Duration p) {
        currentpos =
            p.inMilliseconds; //get the current position of playing audio

        //generating the duration label
        int shours = Duration(milliseconds: currentpos).inHours;
        int sminutes = Duration(milliseconds: currentpos).inMinutes;
        int sseconds = Duration(milliseconds: currentpos).inSeconds;

        int rhours = shours;
        int rminutes = sminutes - (shours * 60);
        int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

        currentpostlabel = "$rhours:$rminutes:$rseconds";

        setState(() {
          //refresh the UI
        });
      }));
    });
    super.initState();
  }

  @override
  void dispose() {
    streams.forEach((it) => it.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                SizedBox(
                  height: 65,
                ),
                CustomText(
                  text: currentAudio.name,
                  fontSize: 32,
                ),
                SizedBox(
                  height: 18,
                ),
                CustomText(
                  text: currentAudio.author,
                  fontSize: 15,
                  color: Color(0xff767373),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: currentpostlabel,
                      fontSize: 15,
                    ),
                    CustomText(
                      text: maxDurationLabel,
                      fontSize: 15,
                    )
                  ],
                ),
                Slider(
                  value: double.parse(currentpos.toString()),
                  min: 0,
                  max: double.parse((maxduration + 1).toString()),
                  activeColor: Colors.black,
                  inactiveColor: Colors.black,
                  divisions: maxduration,
                  label: currentpostlabel,
                  onChanged: (double value) async {
                    int seekval = value.round();
                    await player.seek(Duration(milliseconds: seekval));
                    currentpos = seekval;
                  },
                ),
                SizedBox(
                  height: 51,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () async {
                          await player.stop();
        await player.play(UrlSource(currentAudio.audioFile)); // Replay the current audio
        setState(() {
          isplaying = true;
          audioplayed = true;
        });
                        },
                        iconSize: 35,
                        icon: Icon(Icons.replay_outlined)),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              await player.stop();
                              if (index == 0) {
                                setState(() {
                                index = widget.queue.length - 1;
                                  currentAudio = widget.queue[index];
                                });
                              }else
                              {setState(() {
                                index--;
                              currentAudio = widget.queue[index];
                              });}
                              await player.play(UrlSource(currentAudio.audioFile)); // Load the new audio
        setState(() {
          isplaying = true;
          audioplayed = true;
        });
                            },
                            iconSize: 35,
                            icon: Icon(Icons.skip_previous)),
                        SizedBox(
                          width: 22,
                        ),
                        IconButton(
                            onPressed: () async {
                              if (!isplaying && !audioplayed) {
                                await player
                                    .play(UrlSource(currentAudio.audioFile));
                                setState(() {
                                  isplaying = true;
                                  audioplayed = true;
                                });
                              } else if (audioplayed && !isplaying) {
                                await player.resume();
                                setState(() {
                                  isplaying = true;
                                  audioplayed = true;
                                });
                              } else {
                                await player.pause();
                                setState(() {
                                  isplaying = false;
                                });
                              }
                            },
                            iconSize: 35,
                            icon: Icon(
                                isplaying ? Icons.pause : Icons.play_arrow)),
                        SizedBox(
                          width: 22,
                        ),
                        IconButton(
                            onPressed: () async {
                              await player.stop();
                              if (index == widget.queue.length-1) {
                                setState(() {
                                index = 0;
                                  currentAudio = widget.queue[index];
                                });
                              }else
                              {setState(() {
                                index++;
                              currentAudio = widget.queue[index];
                              });}
                              await player.play(UrlSource(currentAudio.audioFile)); // Load the new audio
        setState(() {
          isplaying = true;
          audioplayed = true;
        });
                            },
                            iconSize: 35,
                            icon: Icon(Icons.skip_next)),
                      ],
                    ),
                    IconButton(
                        onPressed: () {},
                        iconSize: 35,
                        icon: Icon(Icons.audiotrack))
                  ],
                ),
                SizedBox(
                  height: 46,
                )
              ],
            )),
        Transform.translate(
          offset: Offset(0, -120),
          child: Align(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LimitedBox(
                      maxWidth: 188,
                      maxHeight: 175,
                      child: AspectRatio(
                          aspectRatio: 188 / 175,
                          child: Image.network(
                            currentAudio.image,
                            fit: BoxFit.cover,
                          ))))),
        )
      ],
    );
  }
}
