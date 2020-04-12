import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './productItem.widget.dart';
import '../providers/products.provider.dart';

//we extracted the gridview to ensure its the only one that would be rebuilt based on changes it listens out for
//from the provider. i.e. appbar above, wont be rebuilt
class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorites;
  ProductsGrid(this.showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    //below is how we setup the listener/connection to the products provider
    //as long as the provider instance has been provided someone in the upper part of the widget tree that this widget has access to
    //in this case that being within the change provider in myapp in main.dart
    final productsData = Provider.of<ProductsProvider>(context);
    final loadedProducts = showOnlyFavorites ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, i) {
        final product = loadedProducts[i];
        //we are setting up a notifier provider here cos we want to listen out for changes to the product model, which is different from the store (products provider)
        //the product model has a change notifier targeted at notifying of changes to the isbool property
        return ChangeNotifierProvider.value(
          //create: (ctx) => product,
          //when we are using the change provider within a builder widget, it is recommended we use this approach
          //instead of the approach of using the create property which exposes the context to us
          value: product,
          child: ProductItem(),
        );
      },
      padding: const EdgeInsets.all(10.0),
      itemCount: loadedProducts.length,
    );
  }
}
