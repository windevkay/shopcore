import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
// screens
import './screens/productsoverview.screen.dart';
import './screens/orders.screen.dart';
import './screens/productDetail.screen.dart';
import './screens/cart.screen.dart';
import './screens/userProducts.screen.dart';
import './screens/editProduct.screen.dart';
import './screens/auth_screen.dart';
import './screens/splashScreen.screen.dart';
// providers
import './providers/products.provider.dart';
import './providers/orders.provider.dart';
import './providers/auth.provider.dart';
// models
import './models/cart.model.dart';
//helpers
import './helpers/customRoute.helper.dart';

//void main() => runApp(MyApp());

Future main() async {
  // load environment variables
  await DotEnv().load('.env');
  return runApp(MyApp());
}

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
            create: (ctx) => AuthProvider(),
          ),
          // the pattern below wirh change notifier proxy provider, is used when a provider depends on another
          // here we need access to the auth object, hence why we use the pattern
          // if the data in the auth object changes, the depender also rebuilds
          // the update function also gives access to what we can describe as the previous state of the provider
          // represented here as previousProductsProvider
          ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
            create: (_) => ProductsProvider(),
            update: (ctx, auth, previousProductsProvider) =>
                // products provider has multiple properties depending on auth so we use this pattern
                previousProductsProvider
                  ..updateProperties(auth.token, auth.userId),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
            create: (_) => OrdersProvider(),
            update: (ctx, auth, previousOrdersProvider) =>
                //previousOrdersProvider..authToken = auth.token,
                previousOrdersProvider
                  ..updateProperties(auth.token, auth.userId),
          ),
        ],
        child: Consumer<AuthProvider>(
          //using this pattern here cos we wanna rebuild based on auth status
          builder: (ctx, auth, _) => MaterialApp(
              title: 'ShopCore',
              theme: ThemeData(
                  primarySwatch: Colors.pink,
                  accentColor: Colors.amber,
                  fontFamily: 'Lato',
                  //using an optional app-wide screen transition theme
                  pageTransitionsTheme: PageTransitionsTheme(
                    builders: {
                      TargetPlatform.android: CustomPageTransitionBuilder(),
                      TargetPlatform.iOS: CustomPageTransitionBuilder()
                    },
                  )),
              // decide initial screen based on login status
              home: auth.isAuth
                  ? ProductsOverviewScreen()
                  : FutureBuilder(
                      //use this pattern to try to auto relogin, if that isnt possible then show auth screen
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen()),
              routes: {
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
              }),
        ));
  }
}
