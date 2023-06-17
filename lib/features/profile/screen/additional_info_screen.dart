import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/common/utils/translation.dart';
import 'package:flutter_application_audioplayer/features/profile/service/profile_service.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_audioplayer/common/utils/show_sncakbar.dart';
import 'package:flutter_application_audioplayer/common/widgets/custom_widget.dart';
import 'package:flutter_application_audioplayer/constansts/const.dart';
import 'package:flutter_application_audioplayer/features/home/screen/home_screen.dart';
import 'package:flutter_application_audioplayer/features/signup/service/firebase_signup.dart';
import 'package:flutter_application_audioplayer/models/user.dart';
import 'package:flutter_application_audioplayer/providers/user_provider.dart';

class AdditionalInfoScreen extends StatefulWidget { //After registering via social media, prompt users to provide additional details relevant to their assignment requirements 
  AdditionalInfoScreen({
    Key? key,
    required this.credential,
  }) : super(key: key);
  final UserCredential credential;
  static const routeName = '/add-info';

  @override
  State<AdditionalInfoScreen> createState() => _AdditionalInfoScreenState();
}

class _AdditionalInfoScreenState extends State<AdditionalInfoScreen> {
  UserRole _userRole = UserRole.user;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name = '';

  final auth =
      FirebaseSignUp(FirebaseAuth.instance, FirebaseFirestore.instance);

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context,
          listen:
              false); // Utilize Provider to handle the flow of data between different widgets and screens. //
      UserModel user = UserModel(
        id: widget.credential.user!.uid,
        name: _name,
        email: widget.credential.user!.email == null ? 'twitter@gmail.com': widget.credential.user!.email!,
        role: _userRole,
      );
      userProvider.setUserFromModel(user);
      await ProfielService(FirebaseFirestore.instance)
          .updateUserInfo(context, user);
      if (context.mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
      }
    } else {
      showSnackBar(
          context: context,
          content:
              translation(context).formNotValid); //Utilize appropriate Flutter widgets or packages to display informative error messages to users
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = 'New User';
    if (widget.credential.user!.email != null) {
      name = '\n' + widget.credential.user!.email!.split('@')[0];
    }
    if (widget.credential.additionalUserInfo!.username != null) {
      name = '\n' + widget.credential.additionalUserInfo!.username!;
    }
    String title = translation(context).hi(name);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ArrowBackIcon(onPressed: () {
                Navigator.of(context).pop();
              }),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: CustomText(
                    text: title,
                    weight: FontWeight.w200,
                    alignment: TextAlign.left,
                    fontSize: 46,
                  )),
              SizedBox(
                height: 72,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _textFieldBuilder(translation(context).name, (value) {
                        if (value!.isEmpty) {
                          return translation(context).enterYourName;
                        }
                        return null;
                      }, (value) {
                        print(value);
                        _name = value!;
                      }),
                      SwitchListTile(
                        title: Text(_userRole.toString()),
                        value: _userRole != UserRole.user,
                        onChanged: (value) {
                          setState(() {
                            _userRole =
                                value ? UserRole.creator : UserRole.user;
                          });
                        },
                        secondary: Icon(_userRole == UserRole.creator
                            ? Icons.person_add
                            : Icons.person),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        child: CustomText(
                          text: translation(context).guestMode,
                          fontSize: 18,
                          weight: FontWeight.w200,
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              HomeScreen.routeName, (route) => false);
                        },
                      ),
                      Container(
                          width: 64,
                          height: 64,
                          margin: EdgeInsets.only(top: 45),
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(100)),
                          child: IconButton(
                              onPressed: () {
                                _submitForm(context);
                              },
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.keyboard_arrow_right,
                                size: 40,
                              ))),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldBuilder(String hintText, String? Function(String?) callback,
      void Function(String?) onSavedCallback,
      {bool secret = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 18),
      child: TextFormField(
        validator: callback,
        onChanged: onSavedCallback,
        obscureText: secret,
        decoration: InputDecoration(
          fillColor: formFieldBackground,
          filled: true,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 1, color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 1, color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 19),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 0, color: Colors.black12),
          ),
          hintStyle: const TextStyle(
            color: hintColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
