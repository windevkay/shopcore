import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// the keyword show allows us to specify what class within the file we want to expose
import '../providers/orders.provider.dart' show OrdersProvider;
import '../widgets/orderItem.widget.dart';
import '../widgets/appDrawer.widget.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
      ),
    );
  }
}
