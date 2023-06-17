import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/common/widgets/custom_widget.dart';
import 'package:flutter_application_audioplayer/constansts/const.dart';
import 'package:flutter_application_audioplayer/features/audio/screen/audio_screen.dart';
import 'package:flutter_application_audioplayer/models/audio.dart';

class AudioListView extends StatelessWidget {
  final List<Audio> snapshot;
  const AudioListView({
    super.key,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.length,
            itemBuilder: ((context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AudioScreen.routeName, arguments: {
                    "audio": snapshot[index],
                    "queue": snapshot,
                    "index": index
                  }); //Implement mechanisms to transfer data between different screens or pages in your application.
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 25, left: 38, right: 38),
                  decoration: BoxDecoration(
                      color: Theme.of(context).dialogBackgroundColor,
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 17),
                  child: Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LimitedBox(
                              maxHeight: 100,
                              maxWidth: 80,
                              child: AspectRatio(
                                  aspectRatio: 80 / 100,
                                  child: Image.network(
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                    snapshot[index].image,
                                    fit: BoxFit.contain,
                                  )))),
                      SizedBox(
                        width: 13,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: snapshot[index].name,
                            weight: FontWeight.w400,
                            fontSize: 20,
                          ),
                          CustomText(
                            text: snapshot[index].author,
                            fontSize: 14,
                            color: initials,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: snapshot[index].views.toString(),
                                fontSize: 14,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.visibility)
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            })));
  }
}
