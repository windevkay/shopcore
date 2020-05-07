import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// the keyword show allows us to specify what class within the file we want to expose
import '../providers/orders.provider.dart' show OrdersProvider;
import '../widgets/orderItem.widget.dart';
import '../widgets/appDrawer.widget.dart';

//rather than using a stateful widget which we can use to manually handle and set a loading state
//here we use a different pattern with a future builder which gives us access to a connection state
//due to that we also ensure to use a Consumer pattern for our listener setup
class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrdersProvider>(context, listen: false)
            .fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              // ...handle error
              return Center(
                child: Text('An error occured'),
              );
            } else {
              return Consumer<OrdersProvider>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
