import 'package:flutter/material.dart';

import 'package:flutter_application_audioplayer/common/utils/translation.dart';
import 'package:flutter_application_audioplayer/common/widgets/audio_list_view.dart';
import 'package:flutter_application_audioplayer/constansts/const.dart';
import 'package:flutter_application_audioplayer/features/audio/screen/audio_screen.dart';
import 'package:flutter_application_audioplayer/common/widgets/custom_widget.dart';
import 'package:flutter_application_audioplayer/features/home/screen/search_screen.dart';
import 'package:flutter_application_audioplayer/features/home/service/home_service.dart';
import 'package:flutter_application_audioplayer/mockdata/mockdata.dart';
import 'package:flutter_application_audioplayer/models/audio.dart';
import 'package:flutter_application_audioplayer/providers/favorites_provider.dart';
import 'package:provider/provider.dart';

class MyUploadedScreen extends StatelessWidget {
  static const routeName = '/my-upload-audio';
  MyUploadedScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(SearchScreen.routeName),
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
      body: FutureBuilder(
          future: FirebaseAudioService().UploadedAudios(),
          builder: (context, AsyncSnapshot<List<Audio>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            } else {
              return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 38, bottom: 21),
                          child: CustomText(
                            text: translation(context).myAudios,
                            weight: FontWeight.w200,
                            fontSize: 36,
                            alignment: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AudioListView(snapshot: snapshot.data!)
                         ],
                    );
            }
          }),
    );
  }
}
