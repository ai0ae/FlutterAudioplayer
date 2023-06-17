import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/models/audio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_audioplayer/providers/favorites_provider.dart';
import 'package:provider/provider.dart';

class FirebaseAudioService {
  final CollectionReference _audioCollection =
      FirebaseFirestore.instance.collection('audios');

  Future<void> uploadAudio(Audio audio, File image, File audioFile) async {
    final audioData = audio.toMap();

    // Upload image file
    final imageRef = FirebaseStorage.instance
        .ref()
        .child('audio_images')
        .child('${audio.id}.jpg');
    final imageUploadTask = await imageRef.putFile(image);
    final snapshot = await imageUploadTask.ref.getDownloadURL();
    final String imageUrl = snapshot;
    audioData['image'] = imageUrl;

    // Upload audio file
    final audioRef = FirebaseStorage.instance
        .ref()
        .child('audio_files')
        .child('${audio.id}.mp3');
    final audioUploadTask = audioRef.putFile(audioFile);
    final audioSnapshot = await audioUploadTask.whenComplete(() => null);
    final audioUrl = await audioSnapshot.ref.getDownloadURL();
    audioData['audioFile'] = audioUrl;

    // Upload audio data to Firestore
    await _audioCollection.doc(audio.id).set(audioData);
  }

  Future<List<Audio>> searchAudios(String query) async {
    final querySnapshot =
        await _audioCollection.where('name', isEqualTo: query).get();

    final List<Audio> audioList = [];

    for (final doc in querySnapshot.docs) {
      final audio = Audio.fromMap(doc.data() as Map<String, dynamic>);
      audioList.add(audio);
    }

    return audioList;
  }
  void incrementAudioViews(String audioId) {
  // Get the reference to the audio document
  final audioRef = FirebaseFirestore.instance.collection('audios').doc(audioId);

  // Execute a transaction to increment the views field
  FirebaseFirestore.instance.runTransaction((transaction) async {
    final audioSnapshot = await transaction.get(audioRef);
    final currentViews = audioSnapshot['views'] as int;
    final newViews = currentViews + 1;
    transaction.update(audioRef, {'views': newViews});
  }).catchError((error) {
    // Handle any errors that occur during the transaction
    print('Failed to increment audio views: $error');
  });
}
  Future<List<Audio>> fetchAudiosByIds(BuildContext context) async {
  List<Audio> audioList = [];
      final fav = Provider.of<FavoritesProvider>(context, listen: false);
  List <String> favs = await fav.getFavs();
  for (String audioId in favs) {
    Audio? audio = await fetchAudioById(audioId);
    if (audio != null) {
      audioList.add(audio);
    }
  }

  return audioList;
}
Future<Audio?> fetchAudioById(String audioId) async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('audios')
        .doc(audioId)
        .get();

    if (documentSnapshot.exists) {
      // Audio document found
      Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
      
      // Create an instance of the Audio class using the factory constructor
      Audio audio = Audio.fromMap(data);
      
      // Do something with the audio instance
      // ...
      
      return audio; // Return the audio instance
    } else {
      // Audio document not found
      // Handle the case when the audio document doesn't exist
      return null; // Return null or handle the absence of the audio document
    }
  } catch (error) {
    // Error occurred while retrieving audio document
    // Handle the error
    return null; // Return null or handle the error condition
  }
}

  Future<List<Audio>> UploadedAudios() async {
    final querySnapshot = await _audioCollection
        .where('authorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    final List<Audio> audioList = [];

    for (final doc in querySnapshot.docs) {
      final audio = Audio.fromMap(doc.data() as Map<String, dynamic>);
      audioList.add(audio);
    }

    return audioList;
  }

  Future<List<Audio>> getTopFiveAudiosByViews() async {
    final querySnapshot = await _audioCollection
        .orderBy('views', descending: true)
        .limit(5)
        .get();

    return querySnapshot.docs
        .map((doc) => Audio.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Audio>> getPopularAudiosByViews(
      {int limit = 10, DocumentSnapshot? startAfter}) async {
    Query query =
        _audioCollection.orderBy('views', descending: true).limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final querySnapshot = await query.get();

    return querySnapshot.docs
        .map((doc) => Audio.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Audio>> getNewAudio(
      {int limit = 10, DateTime? lastCreatedAt}) async {
    var query =
        _audioCollection.orderBy('createdAt', descending: true).limit(limit);

    if (lastCreatedAt != null) {
      query = query.where('createdAt',
          isLessThan: lastCreatedAt.millisecondsSinceEpoch);
    }

    final querySnapshot = await query.get();

    final List<Audio> audioList = [];

    for (final doc in querySnapshot.docs) {
      final audio = Audio.fromMap(doc.data() as Map<String, dynamic>);
      audioList.add(audio);
    }

    return audioList;
  }
}
