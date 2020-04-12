import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/productsoverview.screen.dart';
import './screens/productDetail.screen.dart';
import './providers/products.provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      //when working with a datastore, we need to return an instance of the provider
      //any changes within the products provider, will trigger a rebuild of all subscribed widgets within the child app
      create: (ctx) => ProductsProvider(),
      child: MaterialApp(
        title: 'ShopCore',
        theme: ThemeData(
            primarySwatch: Colors.pink,
            accentColor: Colors.amber,
            fontFamily: 'Lato'),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        }
      ),
    );
  }
}
