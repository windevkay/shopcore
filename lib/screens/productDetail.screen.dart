import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.provider.dart';

class ProductDetailScreen extends StatelessWidget {
  
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    //get the product id from the routes argument
    final productId = ModalRoute.of(context).settings.arguments as String;
    //this widget arguably does not need to change when there is a change in products
    //cos that wouldnt affect the render or logic of whats going on in here
    //hence we can set listen to false, to ensure we only get data from the store, but do not react to its changes
    final loadedProduct = Provider.of<ProductsProvider>(context, listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(title: Text(loadedProduct.title),),
    );
  }
}