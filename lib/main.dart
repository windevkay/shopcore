import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/productsoverview.screen.dart';
import './screens/productDetail.screen.dart';
import './screens/cart.screen.dart';
import './providers/products.provider.dart';
import './models/cart.model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //we use a multiprovider when we have several providers to specify
      //when working with a datastore, we need to return an instance of the provider
      //any changes within the products provider, will trigger a rebuild of all subscribed widgets within the child app
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
      ],
      child: MaterialApp(
          title: 'ShopCore',
          theme: ThemeData(
              primarySwatch: Colors.pink,
              accentColor: Colors.amber,
              fontFamily: 'Lato'),
          home: ProductsOverviewScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen()
          }),
    );
  }
}
