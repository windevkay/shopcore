import 'package:flutter/foundation.dart';

class CartItem {
  final String id; //this is the id of the item in the cart. not the product id
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    this.quantity = 1,
    @required this.price,
  });
}

class Cart extends ChangeNotifier {
  Map<String, CartItem> _items;

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      //if key exists then update the cart item quantity value
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity + 1),
      );
    } else {//create a new cart item and add to items
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(), title: title, price: price));
    }
  }
}