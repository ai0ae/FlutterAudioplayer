import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_audioplayer/common/utils/translation.dart';
import 'package:flutter_application_audioplayer/features/profile/screen/profile_screen.dart';
import 'package:flutter_application_audioplayer/models/user.dart';
import 'package:flutter_application_audioplayer/providers/user_provider.dart';

class CustomGeneratedDrawer extends StatelessWidget {
  final String profileImage;
  final String name;
  final String email;
  final UserModel user;
  final Function() onUploadMusic;
  final Function() onMyMusics;
  final Function() onFavorites;
  final Function() onLogout;
  final Function() onSettings;

  const CustomGeneratedDrawer({
    Key? key,
    required this.profileImage,
    required this.name,
    required this.email,
    required this.user,
    required this.onUploadMusic,
    required this.onMyMusics,
    required this.onFavorites,
    required this.onLogout,
    required this.onSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProfileScreen.routeName);
            },
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(profileImage),
                  ),
                  SizedBox(height: 10),
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (user.role == UserRole.creator) //Design a user interface that reflects the user's combined roles and provides appropriate functionality based on those roles
            ListTile(
              leading: Icon(Icons.upload),
              title: Text(translation(context).uploadAudio),
              onTap: onUploadMusic,
            ),
          if (user.role == UserRole.creator) //Choose one of the defined roles (e.g., coach, admin) and implement a dedicated page or section for that role.
            ListTile(
              leading: Icon(Icons.music_note),
              title: Text(translation(context).myAudios),
              onTap: onMyMusics,
            ),
          if (user.role != UserRole.guest) //Implement the necessary logic to validate the user's role and handle user addition based on the role's permissions.
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text(translation(context).favs),
              onTap: onFavorites,
            ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(translation(context).settings),
            onTap: onSettings,
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(translation(context).logOut),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
