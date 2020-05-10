import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/httpException.model.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  var authToken = '';

  //final String authToken;
  //ProductsProvider(this.authToken, this._items);

  List<Product> get items {
    //we would use the spread operator here so we dont just return a direct reference in memory to _items
    //this is important as we do not want _items potentialy changed by any other class that gets access to this getter
    // if(_showFavoritesOnly){
    //   return _items.where((product) => product.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  //return a single product filtered by id
  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    //auth tokens needed for requests can be attached as params to the url
    final url = 'https://shopcore-ee439.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(url);
      //FYI is our api needed a token for requests to be on a header, there is a header property available in http.get
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite: prodData['isFavorite'],
            imageUrl: prodData['imageUrl']));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://shopcore-ee439.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite
          }));

      final newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)['name']);

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://shopcore-ee439.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  //here we use an optimistic update pattern
  //and also keep a copy of an item incase deletion fails and we need to rollback
  Future<void> deleteProduct(String id) async {
    final url = 'https://shopcore-ee439.firebaseio.com/products/$id.json?auth=$authToken';
    //get product index and keep a reference to it in memory
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    final response = await http.delete(url);
    _items.removeAt(existingProductIndex);
    notifyListeners();
    //delete requests usually dont throw errors hence we have to check the status code to be sure
    if (response.statusCode >= 400) {
      //in an error case, roll back the deletion and add product back
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      //throw custom exception
      throw HttpException('Could not delete product');
    }
    // in success case, null the product
    existingProduct = null;
  }
}
