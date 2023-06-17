import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/common/utils/translation.dart';
import 'package:flutter_application_audioplayer/constansts/const.dart';
import 'package:flutter_application_audioplayer/features/audio/screen/audio_screen.dart';
import 'package:flutter_application_audioplayer/common/widgets/custom_widget.dart';
import 'package:flutter_application_audioplayer/features/home/service/home_service.dart';
import 'package:flutter_application_audioplayer/features/login/screen/login_screen.dart';
import 'package:flutter_application_audioplayer/models/audio.dart';
import 'package:flutter_application_audioplayer/models/user.dart';
import 'package:flutter_application_audioplayer/providers/favorites_provider.dart';
import 'package:flutter_application_audioplayer/providers/user_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class FavScreen extends StatelessWidget {
  static const routeName = '/fav-page';
  FavScreen({super.key});

  @override
  Widget build(BuildContext context) {
      final fav = Provider.of<FavoritesProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
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
      body:  FutureBuilder(
                  future: FirebaseAudioService().fetchAudiosByIds(context),
                  builder: (context, AsyncSnapshot<List<Audio>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.hasError) {
                        return Center(
                          child: CustomText(text: snapshot.error.toString()),
                        );
                      } else {
                        return  snapshot.data!.isEmpty
                            ? Center(
                                child: CustomText(
                                  text: translation(context).noFav,
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 38, bottom: 21),
                                    child: CustomText(
                                      text: translation(context).favs,
                                      weight: FontWeight.w200,
                                      fontSize: 36,
                                      alignment: TextAlign.left,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                      child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          physics: BouncingScrollPhysics(),
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: ((context, index) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 25,
                                                  left: 38,
                                                  right: 38),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Dismissible(
                                                  direction: DismissDirection
                                                      .endToStart,
                                                  key: ValueKey(snapshot.data![index].id),
                                                  background: Container(
                                                    // most importantly, do not forget to give the inner container a
                                                    // padding to the right so that our icon does not stick to the
                                                    // wall of the container when swiping

                                                    padding:
                                                        const EdgeInsets.only(
                                                      right: 16,
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .error),
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: const Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  onDismissed:
                                                      (direction) async {
                                                    await fav.removeFromFavs(
                                                        snapshot.data![index].id);
                                                  },
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: backgroundColor,
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 17),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                AudioScreen
                                                                    .routeName,
                                                                arguments: {
                                                              "audio":
                                                                  snapshot.data![index],
                                                              "queue": snapshot.data!,
                                                              "index": index
                                                            }); //Implement navigation within your Flutter application using the Navigator package.
                                                      },
                                                      child: Row(
                                                        children: [
                                                          ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child: LimitedBox(
                                                                  maxHeight:
                                                                      100,
                                                                  maxWidth: 80,
                                                                  child:
                                                                      AspectRatio(
                                                                          aspectRatio: 80 /
                                                                              100,
                                                                          child:
                                                                              Image.network(
                                                                            snapshot.data![index].image,
                                                                            fit:
                                                                                BoxFit.contain,
                                                                          )))),
                                                          SizedBox(
                                                            width: 13,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              CustomText(
                                                                text:
                                                                    snapshot.data![index]
                                                                        .name,
                                                                weight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 20,
                                                              ),
                                                              CustomText(
                                                                text:
                                                                    snapshot.data![index]
                                                                        .author,
                                                                fontSize: 14,
                                                                color: initials,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  CustomText(
                                                                    text: snapshot.data![
                                                                            index]
                                                                        .views
                                                                        .toString(),
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                  Icon(Icons
                                                                      .visibility)
                                                                ],
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            3),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child:
                                                                    CustomText(
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
                                              ),
                                            );
                                          })))
                                ],
                              );
                      }
                    }
                  
            
          }),
    );
  }
}
