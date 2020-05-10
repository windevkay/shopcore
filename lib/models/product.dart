import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  //the changenotifier mixin is meant for this property.
  //to let susbscribed widgets know when this boolean changes
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _revertAction(bool status) {
    isFavorite = status;
    notifyListeners();
  }

  // we are using an optimistic update here as well
  Future<void> toggleFavoriteStatus(String token) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://shopcore-ee439.firebaseio.com/products/$id.json?auth=$token';
    try {
      final response =
          await http.patch(url, body: json.encode({'isFavorite': isFavorite}));
      if (response.statusCode >= 400) {
        //if error, roll back
        _revertAction(oldStatus);
      }
    } catch (error) {
      //if error, roll back
      _revertAction(oldStatus);
    }
  }
}
