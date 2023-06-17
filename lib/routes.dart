import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/features/audio/screen/audio_screen.dart';
import 'package:flutter_application_audioplayer/features/home/screen/home_screen.dart';
import 'package:flutter_application_audioplayer/features/home/screen/new_audio.dart';
import 'package:flutter_application_audioplayer/features/home/screen/popular_screen.dart';
import 'package:flutter_application_audioplayer/features/home/screen/search_screen.dart';
import 'package:flutter_application_audioplayer/features/home/service/home_service.dart';
import 'package:flutter_application_audioplayer/features/login/screen/login_screen.dart';
import 'package:flutter_application_audioplayer/features/profile/screen/additional_info_screen.dart';
import 'package:flutter_application_audioplayer/features/profile/screen/profile_screen.dart';
import 'package:flutter_application_audioplayer/features/settings/settings.dart';
import 'package:flutter_application_audioplayer/features/signup/screen/signup_screen.dart';
import 'package:flutter_application_audioplayer/features/upload/screen/my_uploaded_screen.dart';
import 'package:flutter_application_audioplayer/features/upload/screen/upload_music_screen.dart';
import 'package:flutter_application_audioplayer/models/audio.dart';

import 'features/fav/screen/fav_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) { // Utilize named routes and routes table for efficient and structured navigation.
  switch (routeSettings.name) {
    case LoginScreen.routeName: //Implement Email Registration and Login
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => LoginScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => HomeScreen());
    case AudioScreen.routeName:

      Map<String, Object> audio = routeSettings.arguments as Map<String, Object>;
    FirebaseAudioService().incrementAudioViews((audio['audio']! as Audio).id);
      
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => AudioScreen(audio: audio['audio']! as Audio,queue: audio['queue'] as List<Audio>, index: audio['index']as int));
    case AdditionalInfoScreen.routeName:
      UserCredential userCredential = routeSettings.arguments as UserCredential; 
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => AdditionalInfoScreen(credential: userCredential,));
    case SignUpScreen.routeName: //Implement Email Registration and Login
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => SignUpScreen());
    case FavScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => FavScreen());
    case UploadMusicScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => UploadMusicScreen());
    case ProfileScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => ProfileScreen());
    case SettingsScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const SettingsScreen());
    case SearchScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) =>  SearchScreen());
    case NewAudio.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) =>  NewAudio());
    case PopularScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) =>  PopularScreen());
    case MyUploadedScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) =>  MyUploadedScreen());
    default:
      return MaterialPageRoute(
          builder: (c) => const Scaffold(
                body: Center(
                  child: Text('Page Not found'),
                ),
              ));
  }
}
