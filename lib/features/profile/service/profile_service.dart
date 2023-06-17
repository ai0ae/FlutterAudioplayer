import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/common/utils/show_sncakbar.dart';
import 'package:flutter_application_audioplayer/common/utils/translation.dart';

import 'package:flutter_application_audioplayer/models/user.dart';
import 'package:flutter_application_audioplayer/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfielService {
  final FirebaseFirestore _cloud;
  ProfielService(
    this._cloud,
  );

  Future<void> updateUserInfo(BuildContext context, UserModel model) async {
    try {
      UserModel user = Provider.of<UserProvider>(context, listen: false).user;
    if (user.id.isNotEmpty) {
      await _cloud.collection('users').doc(user.id).set(model.toMap());
            if(context.mounted)showSnackBar(context: context, content: translation(context).successUpdate);

    }
    } catch (e){
      showSnackBar(context: context, content: translation(context).wentWrong);
    }
  }
}
