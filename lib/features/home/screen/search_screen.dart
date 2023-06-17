import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/common/widgets/custom_widget.dart';
import 'package:flutter_application_audioplayer/constansts/const.dart';
import 'package:flutter_application_audioplayer/features/audio/screen/audio_screen.dart';
import 'package:flutter_application_audioplayer/features/home/service/home_service.dart';
import 'package:flutter_application_audioplayer/models/audio.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool loading = false;
  List<Audio> gotAudio = [];
  String query = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).viewPadding.top),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back_ios)),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                      onChanged: (val) => query = val,
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        
                        setState(() {
                          loading = true;
                        });
                        gotAudio =
                            await FirebaseAudioService().searchAudios(query);
                        setState(() {
                          loading = false;
                        });
                      },
                      icon: Icon(Icons.search))
                ],
              ),
            ),
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: BouncingScrollPhysics(),
                        itemCount: gotAudio.length,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom: 25, left: 38, right: 38),
                            child: GestureDetector(
                              onTap: () { 
                                    Navigator.of(context)
                      .pushNamed(AudioScreen.routeName, arguments: {
                    "audio": gotAudio[index],
                    "queue": gotAudio,
                    "index": index
                  });  //Implement navigation within your Flutter application using the Navigator package.
                                  },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: backgroundColor,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 17),
                                  child: Row(
                                    children: [
                                      ClipRRect(borderRadius: BorderRadius.circular(10),child: LimitedBox(maxHeight: 100, maxWidth: 80,child: AspectRatio(aspectRatio: 80/100,child: Image.network(gotAudio[index].image, fit: BoxFit.contain,)))), 
                                      SizedBox(
                                        width: 13,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomText(
                                            text: gotAudio[index].name,
                                            weight: FontWeight.w400,
                                            fontSize: 20,
                                          ),
                                          CustomText(
                                            text: gotAudio[index].author,
                                            fontSize: 14,
                                            color: initials,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              CustomText(
                                                text: gotAudio[index]
                                                    .views
                                                    .toString(),
                                                fontSize: 14,
                                              ),
                                              Icon(Icons.visibility)
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: CustomText(
                                              text: 'play',
                                              fontSize: 16,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })))
          ],
        ),
      ),
    );
  }
}
