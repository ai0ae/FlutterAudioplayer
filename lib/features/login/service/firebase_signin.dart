import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/common/utils/show_sncakbar.dart';
import 'package:flutter_application_audioplayer/features/home/screen/home_screen.dart';
import 'package:flutter_application_audioplayer/features/login/screen/login_screen.dart';
import 'package:flutter_application_audioplayer/features/profile/screen/additional_info_screen.dart';
import 'package:flutter_application_audioplayer/models/user.dart';
import 'package:flutter_application_audioplayer/providers/user_provider.dart';
// import 'package:github_sign_in_plus/github_sign_in_plus.dart';
import 'package:github_signin_promax/github_signin_promax.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:twitter_login/twitter_login.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  final FirebaseFirestore _cloud;

  FirebaseAuthMethods(this._auth, this._cloud);

  // FOR EVERY FUNCTION HERE
  // POP THE ROUTE USING: Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

  // GET USER DATA
  // using null check operator since this method should be called only
  // when the user is logged in
  User get user => _auth.currentUser!;

  // STATE PERSISTENCE STREAM
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();
  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await _cloud.collection('users').doc(_auth.currentUser?.uid).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  // EMAIL LOGIN
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!user.emailVerified) {
        if (context.mounted) await sendEmailVerification(context);
        if (context.mounted) {
          showSnackBar(
              context: context, content: 'you should first verify your email');
        }
      } else {
        final map = await _cloud.collection('users').doc(user.uid).get();
        final UserModel model = UserModel.fromMap(map.data()!);
        if (context.mounted) {
          Provider.of<UserProvider>(context, listen: false).setUserFromModel(
              UserModel(
                  id: user.uid,
                  name: model.name,
                  email: email,
                  role: model.role));
          Navigator.of(context)
              .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(
          context: context,
          content: e.message!); // Displaying the error message
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      if (context.mounted) {
        showSnackBar(context: context, content: 'Email verification sent!');
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(
          context: context, content: e.message!); // Display error message
    }
  }

  // GOOGLE SIGN IN
  Future<void> signInWithGoogle(BuildContext context) async { //Integrate authentication with at least three social media platforms (e.g., Google, Facebook, Twitter, VK, etc.).
    try {
      // if (kIsWeb) {
      //   GoogleAuthProvider googleProvider = GoogleAuthProvider();

      //   googleProvider
      //       .addScope('https://www.googleapis.com/auth/contacts.readonly');

      //   await _auth.signInWithPopup(googleProvider);
      // } else {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        // if you want to do specific task like storing information in firestore
        // only for new users using google sign in (since there are no two options
        // for google sign in and google sign up, only one as of now),
        // do the following:

        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            Navigator.of(context).pushNamed(AdditionalInfoScreen.routeName, arguments: userCredential);
          }
        }
      }
      // }
    } on FirebaseAuthException catch (e) {
      showSnackBar(
          context: context,
          content: e.message!); // Displaying the error message
    }
  }

  Future<void> signInWithTwitter(BuildContext context) async { //Integrate authentication with at least three social media platforms (e.g., Google, Facebook, Twitter, VK, etc.).
    // Create a TwitterLogin instance
    final twitterLogin = TwitterLogin(
        apiKey: 'l3aNZ0RigsEfxAGYwUhhcInDU',
        apiSecretKey: 'v6xc8UqOGJ3aexUjuYFadx2S2tKDQfX3OW63oF7DmHaOWROzLn',
        redirectURI: 'flutter-twitter-practice://');

    // Trigger the sign-in flow
    await twitterLogin.login().then((value) async {
      final twitterAuthCredential = TwitterAuthProvider.credential(
        accessToken: value.authToken!,
        secret: value.authTokenSecret!,
      );

      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(twitterAuthCredential);
      if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            if (context.mounted)Navigator.of(context).pushNamed(AdditionalInfoScreen.routeName, arguments: userCredential);
          }
        }
    });
  }

  Future<void> signInWithGithub(BuildContext context) async { //Integrate authentication with at least three social media platforms (e.g., Google, Facebook, Twitter, VK, etc.).
    // final GitHubSignIn gitHubSignIn = GitHubSignIn(
    //     clientId: 'a241df6e32bb1eb20b1c',
    //     clientSecret: '7f4aca9a707d49a3d7ac48f8d5d78cb2b64811ef',
    //     redirectUrl:
    //         'https://flutter-assignment-2837f.firebaseapp.com/__/auth/handler');

    // var result = await gitHubSignIn.signIn(context);
    // create required params
    var params = GithubSignInParams(
      clientId: 'a241df6e32bb1eb20b1c',
      clientSecret: '7f4aca9a707d49a3d7ac48f8d5d78cb2b64811ef',
      redirectUrl:
          'https://flutter-assignment-2837f.firebaseapp.com/__/auth/handler',
      scopes: 'read:user,user:email',
    );

    // Push [GithubSigninScreen] to perform login then get the [GithubSignInResponse]
    final value =
        await Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
      return GithubSigninScreen(
        params: params,
        headerColor: Colors.green,
        title: 'Login with github',
      );
    }));
    // OAuthCredential credential = GithubAuthProvider.credential(result.token!);
    print(value);
    // final userCredential =
    //     await FirebaseAuth.instance.signInWithCredential(credential);
    // if (userCredential.user != null) {
    //       if (userCredential.additionalUserInfo!.isNewUser) {
    //         if (context.mounted)Navigator.of(context).pushNamed(AdditionalInfoScreen.routeName, arguments: userCredential);
    //       }
    //     }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      Provider.of<UserProvider>(context, listen: false).logOut();
      await _auth.signOut();
      if (context.mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(
          context: context,
          content: e.message!); // Displaying the error message
    }
  }

  // DELETE ACCOUNT
  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      showSnackBar(
          context: context,
          content: e.message!); // Displaying the error message
      // if an error of requires-recent-login is thrown, make sure to log
      // in user again and then delete account.
    }
  }
}
