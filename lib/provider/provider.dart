import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteProvider extends ChangeNotifier {
  List<int> _id = [];
  List<int> get id => _id;

  void toggleFavorite(int id) {
    final isExist = _id.contains(id);
    if (isExist) {
      _id.remove(id);
    } else {
      _id.add(id);
    }
    notifyListeners();
  }

  bool isExist(int id) {
    final isExist = _id.contains(id);
    return isExist;
  }

  void clearFavorite() {
    _id = [];
    notifyListeners();
  }

  static FavoriteProvider of(
    BuildContext context, {
    bool listen = true,
  }) {
    return Provider.of<FavoriteProvider>(
      context,
      listen: listen,
    );
  }
}
