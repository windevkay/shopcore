import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/httpException.model.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  String firebaseKey = DotEnv().env['FIREBASE_KEY'];

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String apiUrl) async {
    try {
      final response = await http.post(apiUrl,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      // expires in value from firebase comes in seconds, so simply add that to current time
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    // for enabled email and password signups using firebase, there is a specific endpoint
    // the key here is your firebase console app key
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$firebaseKey';
    return _authenticate(email, password, url);
  }

  Future<void> login(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$firebaseKey';
    return _authenticate(email, password, url);
  }
}
