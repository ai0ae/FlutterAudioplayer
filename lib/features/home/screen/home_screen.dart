import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/common/utils/translation.dart';
import 'package:flutter_application_audioplayer/common/widgets/audio_list_view.dart';
import 'package:flutter_application_audioplayer/common/widgets/custom_drawer.dart';
import 'package:flutter_application_audioplayer/constansts/const.dart';
import 'package:flutter_application_audioplayer/features/audio/screen/audio_screen.dart';
import 'package:flutter_application_audioplayer/common/widgets/custom_widget.dart';
import 'package:flutter_application_audioplayer/features/fav/screen/fav_screen.dart';
import 'package:flutter_application_audioplayer/features/home/screen/new_audio.dart';
import 'package:flutter_application_audioplayer/features/home/screen/popular_screen.dart';
import 'package:flutter_application_audioplayer/features/home/screen/search_screen.dart';
import 'package:flutter_application_audioplayer/features/home/service/home_service.dart';
import 'package:flutter_application_audioplayer/features/login/screen/login_screen.dart';
import 'package:flutter_application_audioplayer/features/login/service/firebase_signin.dart';
import 'package:flutter_application_audioplayer/features/settings/settings.dart';
import 'package:flutter_application_audioplayer/features/upload/screen/my_uploaded_screen.dart';
import 'package:flutter_application_audioplayer/features/upload/screen/upload_music_screen.dart';
import 'package:flutter_application_audioplayer/models/audio.dart';
import 'package:flutter_application_audioplayer/models/user.dart';
import 'package:flutter_application_audioplayer/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-page';
  HomeScreen({super.key});
  final pageController =
      PageController(viewportFraction: 1 / 1.19, initialPage: 999);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: true).user;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(SearchScreen.routeName);
            },
            icon: const Icon(
              Icons.search,
              size: 40,
            ),
          )
        ],
        elevation: 0,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              Icons.menu,
              size: 40,
            ),
          );
        }),
      ),
      drawer:
          CustomDrawer(), //Enhance the navigation by implementing either tabs or drawers to provide a multi-level navigation experience.
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 21,
          ),
          Padding(
            padding: EdgeInsets.only(left: 38, bottom: 21),
            child: CustomText(
              color: const Color.fromARGB(255, 0, 0, 0),
              text: translation(context).popularBooks,
              weight: FontWeight.w200,
              fontSize: 36,
              alignment: TextAlign.left,
            ),
          ),
          SizedBox(
              height: 160,
              child: FutureBuilder(
                  future: FirebaseAudioService().getTopFiveAudiosByViews(),
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
                        return PageView.builder(
                          physics: const BouncingScrollPhysics(),
                          // itemCount: ,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                      .pushNamed(AudioScreen.routeName, arguments: {
                    "audio": snapshot.data![index %
                                                      snapshot.data!.length],
                    "queue": snapshot.data!,
                    "index": index%
                                                      snapshot.data!.length
                  });  //Implement mechanisms to transfer data between different screens or pages in your application.
                                },
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LimitedBox(
                                        maxHeight: 352,
                                        maxWidth: 160,
                                        child: AspectRatio(
                                            aspectRatio: 352 / 160,
                                            child: Image.network(
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
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
                                              snapshot
                                                  .data![index %
                                                      snapshot.data!.length]
                                                  .image,
                                              fit: BoxFit.cover,
                                            )))),
                              ),
                            );
                          },
                          controller: pageController,
                        );
                      }
                    }
                  })),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (user.role != UserRole.guest)
                GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushNamed(FavScreen.routeName),
                    child: _buildCategories(translation(context).my, yellow)),
              GestureDetector(onTap: () => Navigator.of(context).pushNamed(NewAudio.routeName),child: _buildCategories(translation(context).newIdent, red)),
              GestureDetector(onTap: () => Navigator.of(context).pushNamed(PopularScreen.routeName),child: _buildCategories(translation(context).trending, green)),
            ],
          ),
          SizedBox(
            height: 23,
          ),
          FutureBuilder(
              future: FirebaseAudioService().getPopularAudiosByViews(),
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
                    return AudioListView(snapshot: snapshot.data!,);
                  }
                }
              })
        ],
      ),
    );
  }

  Container _buildCategories(String text, Color color) {
    return Container(
      width: 123,
      height: 49,
      alignment: Alignment.center,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: CustomText(
        text: text,
        weight: FontWeight.w200,
        fontSize: 24,
      ),
    );
  }
}


class CustomDrawer extends StatelessWidget {
  //Enhance the navigation by implementing either tabs or drawers to provide a multi-level navigation experience. // Design and implement a visually appealing user interface for the tabs or drawers.
  CustomDrawer({
    super.key,
  });
  final _auth =
      FirebaseAuthMethods(FirebaseAuth.instance, FirebaseFirestore.instance);
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(
        context); // Utilize Provider to handle the flow of data between different widgets and screens. // Demonstrate the use of Provider to manage and update the application state efficiently.
    final UserModel user = userProvider.user;
    return CustomGeneratedDrawer(
      user: user,
      profileImage: user.userImage,
      name: user.name,
      email: user.email,
      onUploadMusic: () {
        // Handle upload music navigation
        Navigator.of(context).pushNamed(UploadMusicScreen.routeName);
      },
      onMyMusics: () {
        // Handle my musics navigation
              Navigator.of(context).pushNamed(MyUploadedScreen.routeName);

      },
      onFavorites: () {
        // Handle favorites navigation
        Navigator.of(context).pushNamed(FavScreen.routeName);
      },
      onLogout: () {
        _auth.signOut(context);
      },
      onSettings: () {
        Navigator.of(context).pushNamed(SettingsScreen.routeName);
      },
    );
  }
}

// FutureBuilder(
//               future: FirebaseAudioService().getPopularAudiosByViews(),
//               builder: (context, AsyncSnapshot<List<Audio>> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }else {
//                   if(snapshot.hasError) {
// return Center(
//                       child: CustomText(text: snapshot.error.toString()),
//                     );
//                   }else {
                    
//                   }
//                 }
//               })
