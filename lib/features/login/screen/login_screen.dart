import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/common/utils/translation.dart';
import 'package:flutter_application_audioplayer/constansts/const.dart';
import 'package:flutter_application_audioplayer/features/login/service/firebase_signin.dart';
import 'package:flutter_application_audioplayer/features/settings/settings.dart';
import 'package:flutter_application_audioplayer/features/signup/screen/signup_screen.dart';
import 'package:flutter_application_audioplayer/common/widgets/custom_widget.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class LoginScreen extends StatefulWidget {
  //Implement Email Registration and Login
  static const routeName = '/login-page';
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum LoginField { email, password }

class _LoginScreenState extends State<LoginScreen> {
  late FirebaseAuthMethods auth;
  @override
  void initState() {
    // TODO: implement initState
    auth =
        FirebaseAuthMethods(FirebaseAuth.instance, FirebaseFirestore.instance);
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  String title = '';
  bool changePassword = false;
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    if (title.isEmpty) {
      title = translation(context).welcomeBack;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              changePassword
                  ? ArrowBackIcon(onPressed: () {
                      setState(() {
                        title = translation(context).welcomeBack;
                        changePassword = false;
                      });
                    })
                  : SizedBox(
                      height: 110,
                    ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Theme.of(context).dialogBackgroundColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: CustomText(
                    text: title,
                    weight: FontWeight.w200,
                    alignment: TextAlign.left,
                    fontSize: 46,
                  )),
              SizedBox(
                height: 50,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _textFieldBuilder(translation(context).yourEmail, LoginField.email),
                      const SizedBox(
                        height: 10,
                      ),
                      _textFieldBuilder(translation(context).password, LoginField.password),
                      const SizedBox(
                        height: 30,
                      ),
                      // SocialLoginButton( //Implement a social media login screen that allows users to authenticate using their social media accounts
                      //   buttonType: SocialLoginButtonType.github,
                      //   onPressed: () {
                      //     auth.signInWithGithub(context);
                      //   },
                      // ),
                      // const SizedBox(height: 10),
                      // SocialLoginButton(
                      //   buttonType: SocialLoginButtonType.twitter,
                      //   onPressed: () {
                      //     auth.signInWithTwitter(context);
                      //   },
                      // ),
                      const SizedBox(height: 10),
                      SocialLoginButton(
                        buttonType: SocialLoginButtonType.google,
                        onPressed: () {
                          auth.signInWithGoogle(context);
                        },
                      ),
                      const SizedBox(height: 10),

                      SocialLoginButton(
                        buttonType: SocialLoginButtonType.generalLogin,
                        backgroundColor: Colors.blueGrey,
                        onPressed: () {
                          auth.loginWithEmail(
                              email: email,
                              password: password,
                              context: context);
                        },
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        expandedFabSize: ExpandableFabSize.regular,
        children: [
          FloatingActionButton(
            heroTag: null,
            child:  Icon(Icons.password,),
            onPressed: () {
              setState(() {
                title = translation(context).forgorPasswordTitle;
                changePassword = true;
              });
            },
          ),
          FloatingActionButton(
            heroTag: null,
            child: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(SettingsScreen.routeName);
            },
          ),
          FloatingActionButton(
            heroTag: null,
            child: const Icon(Icons.person_add_alt_sharp),
            onPressed: () {
              Navigator.of(context).pushNamed(SignUpScreen.routeName);
            },
          ),
        ],
      ),
    );
  }

  Widget _textFieldBuilder(String hintText, LoginField field) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: formFieldBackground),
        child: TextFormField(
          onChanged: (value) {
            switch (field) {
              case LoginField.email:
                email = value;
                break;
              case LoginField.password:
                password = value;
                break;
            }
          },
          decoration: InputDecoration(
            
              hintText: hintText),
        ));
  }
}
