import '../../core/data/data_provider.dart';
import '../tracking_screen/tracking_screen.dart';
import '../../utility/app_color.dart';
import '../../utility/extensions.dart';
import '../../utility/utility_extention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../widget/order_tile.dart';

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.dataProvider.getAllOrderByUser(context.userProvider.getLoginUsr());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.darkOrange,
          ),
        ),
      ),
      body: Consumer<DataProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: context.dataProvider.orders.length,
            itemBuilder: (context, index) {
              final order = context.dataProvider.orders[index];
              return OrderTile(
                paymentMethod: order.paymentMethod ?? '',
                items:
                '${(order.items.safeElementAt(0)?.productName ?? '')} x${order.items.safeElementAt(0)?.quantity ?? 1}',
                date: order.orderDate ?? '',
                status: order.orderStatus ?? 'pending',
                onTap: () {
                  if (order.orderStatus == 'shipped') {
                    Get.to(TrackingScreen(url: order.trackingUrl ?? ''));
                  }
                },
                trailing: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Cancel Order"),
                            content: const Text("Are you sure you want to cancel this order?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("No"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Yes"),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmed == true) {
                        final success = await context.dataProvider.deleteOrder(order.sId!);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Order cancelled successfully")),
                          );
                          context.dataProvider.orders.removeAt(index);
                          context.dataProvider.notifyListeners(); // <-- Fixed here
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Failed to cancel order")),
                          );
                        }
                      }
                    },
                  ),

                );
            },
          );
        },
      ),
    );
  }
}
