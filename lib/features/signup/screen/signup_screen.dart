import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/common/utils/show_sncakbar.dart';
import 'package:flutter_application_audioplayer/common/utils/translation.dart';
import 'package:flutter_application_audioplayer/constansts/const.dart';
import 'package:flutter_application_audioplayer/features/home/screen/home_screen.dart';
import 'package:flutter_application_audioplayer/common/widgets/custom_widget.dart';
import 'package:flutter_application_audioplayer/features/signup/service/firebase_signup.dart';
import 'package:flutter_application_audioplayer/models/user.dart';
import 'package:flutter_application_audioplayer/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget { //Implement Email Registration and Login
  SignUpScreen({super.key});
  static const routeName = '/signup-page';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  UserRole _userRole = UserRole.user;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = '';

  String _password = '';

  String _name = '';

  final auth =
      FirebaseSignUp(FirebaseAuth.instance, FirebaseFirestore.instance);

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context,
          listen:
              false); 
      UserModel user = UserModel(
        id: '',
        name: _name,
        email: _email,
        role: _userRole, //Ensure that the selected role is stored and associated with the user's account for future authentication and role-based access control.
      );
      String? uid = await auth.signUpWithEmail(
          userModel: user, password: _password, context: context);

      if (uid != null) {
        user = user.copyWith(id: uid);
        userProvider.setUserFromModel(user);
        if (context.mounted)
          Navigator.of(context)
              .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
      } else {
        if (context.mounted) {
          showSnackBar(context: context, content: translation(context).wentWrong);
        }
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
    
  String title = translation(context).createAccountTitle;
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
                      color: Theme.of(context).dialogBackgroundColor,
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
                      _textFieldBuilder(
                        translation(context).yourEmail,
                        (value) {
                          if (value!.isEmpty) {
                            return translation(context).emailEnter;
                          }
                          if (!value.contains('@')) {
                            return translation(context).emailEnterNotValid;
                          }
                          return null;
                        },
                        (value) {
                          _email = value!;
                        },
                      ),
                      _textFieldBuilder('Password', (value) {
                        if (value!.isEmpty) {
                          return translation(context).enterPassword;
                        }
                        if (value.length < 6) {
                          return translation(context).validPassword;
                        }
                        return null;
                      }, (value) {
                        _password = value!;
                      }, secret: true),
                      SwitchListTile( //Define at least two user roles //Implement a feature that allows users to select their role during the authorization process
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
                        child: CustomText( //Design a guest mode that allows users to access general information, advertisements, feedback, etc., without requiring authentication
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
                              color: Theme.of(context).dialogBackgroundColor,
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
          hintText: hintText,
        ),
      ),
    );
  }
}
