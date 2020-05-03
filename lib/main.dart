import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// screens
import './screens/productsoverview.screen.dart';
import './screens/orders.screen.dart';
import './screens/productDetail.screen.dart';
import './screens/cart.screen.dart';
import './screens/userProducts.screen.dart';
import './screens/editProduct.screen.dart';
// providers
import './providers/products.provider.dart';
import './providers/orders.provider.dart';
// models
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
        ChangeNotifierProvider(
          create: (ctx) => OrdersProvider(),
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
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen()
          }),
    );
  }
}
