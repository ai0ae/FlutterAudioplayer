import 'package:flutter/cupertino.dart';
import 'package:flutter_application_audioplayer/features/fav/service/local_storage.dart';
import 'package:uuid/uuid.dart';

import '../models/audio.dart';

class FavoritesProvider extends ChangeNotifier {
  List<String> _favs = [];

  List<String> get favs => _favs;

  void addFavs(String id) async {
    _favs.add(id);
    await DBHelper.insert(
        DBHelper.product, {'id': const Uuid().v1(), 'uuid': id});
    notifyListeners();
  }

  Future<bool> isFav(String id) async {
    bool firstCheck = _favs.indexWhere((element) => element == id) != -1;
    if (firstCheck) {
      return firstCheck;
    }
    var db = await DBHelper.selectProductById(id);
    var temp = db.length;
    return temp != 0;
  }

  Future<void> removeFromFavs(String id) async {
    _favs.removeWhere((element) => element == id);
    await DBHelper.deleteById(DBHelper.product, 'uuid', id);
    notifyListeners();
  }

// show items
  Future<List<String>> getFavs() async {
    final dataList = await DBHelper.selectFavs();
    _favs = dataList;
    return dataList;
  }

  Future deleteTable() async {
    await DBHelper.deleteTable(DBHelper.product);
    _favs = [];
    notifyListeners();
  }
}
