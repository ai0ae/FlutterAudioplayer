import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/common/utils/show_sncakbar.dart';
import 'package:flutter_application_audioplayer/models/user.dart';

class FirebaseSignUp {
  final FirebaseAuth _auth;
  final FirebaseFirestore firestore;

  FirebaseSignUp(this._auth, this.firestore);
  // EMAIL SIGN UP
  Future<String?> signUpWithEmail({
    required UserModel userModel,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: password,
      ); //Implement password hashing to securely store and compare user passwords
      String uid = user.user!.uid;
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      // if (profilePic != null) {
      //   photoUrl = await ref
      //       .read(commonFirebaseStorageRepositoryProvider)
      //       .storeFileToFirebase(
      //         'profilePic/$uid',
      //         profilePic,
      //       );
      // }

      await firestore.collection('users').doc(uid).set(userModel.toMap());
      await sendEmailVerification(context);
      return user.user!.uid;
    } on FirebaseAuthException catch (e) {
      //      --if you want to display your own custom error message
      // if (e.code == 'weak-password') {
      //   print('The password provided is too weak.');
      // } else if (e.code == 'email-already-in-use') {
      //   print('The account already exists for that email.');
      // }
      showSnackBar(
          context: context,
          content: e.message!); // Displaying the usual firebase error message
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async { //Implement email verification for newly registered users.
    try {
      _auth.currentUser!.sendEmailVerification(); //Implement email verification for newly registered users.
      showSnackBar(context: context, content: 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(
          context: context, content: e.message!); // Display error message
    }
  }
}
