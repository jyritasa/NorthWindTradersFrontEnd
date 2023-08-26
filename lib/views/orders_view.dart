import 'package:flutter/material.dart';
import 'package:northwind/components/orders/orders_breakdown.dart';
import 'package:northwind/conf/fonts_and_padding.dart';
import 'package:northwind/models/order_model.dart';
import 'package:northwind/views/shared/view_class.dart';
import 'package:northwind/views/single_order_view.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewFromModel<Order>(
      fromJson: Order.fromJson,
      tileTitleWidget: (order) {
        DateTime? shippedDate;
        DateTime? orderDate = DateTime.tryParse(order.orderDate ?? "");
        if (order.shippedDate != null) {
          shippedDate = DateTime.tryParse(order.shippedDate ?? "");
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(order.orderId.toString()),
            const Padding(
              padding: EdgeInsets.only(right: inBetweenPadding),
            ),
            (order.shippedDate != null)
                ? Text(
                    "Shipped Date: ${shippedDate?.day}.${shippedDate?.month}.${shippedDate?.year}",
                  )
                : Text(
                    "Order Date: ${orderDate?.day}.${orderDate?.month}.${orderDate?.year}",
                  ),
            Expanded(
              child: Container(),
            ),
            Icon(
              (order.shippedDate == null)
                  ? Icons.pending_actions
                  : Icons.local_shipping_outlined,
              color: (order.shippedDate == null) ? Colors.red : Colors.green,
              size: 64,
            ),
          ],
        );
      },
      tileSubTitleWidget: (order) => Text(order.customer?.companyName ?? ""),
      tileInnerWidget: (order) => Column(
        children: [
          orderBreakDownWidget(order),
          const Padding(padding: EdgeInsets.only(bottom: inBetweenPadding)), //
          ElevatedButton(
            child: const Text("More Information"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleOrderView(order: order),
                ),
              );
            },
          ),
        ],
      ),
      searchFilter: (orders, text) {
        var newList = orders.where((order) {
          DateTime? shippedDate;
          DateTime? orderDate = DateTime.tryParse(order.orderDate ?? "");
          String orderDateString =
              "${orderDate?.day}.${orderDate?.month}.${orderDate?.year}";
          String? shippedDateString;
          if (order.shippedDate != null) {
            shippedDate = DateTime.tryParse(order.shippedDate ?? "");
            shippedDateString =
                "${shippedDate?.day}.${shippedDate?.month}.${shippedDate?.year}";
          }
          bool shippedDateTest() {
            if (shippedDate == null) return false;
            if (shippedDateString == null) return false;
            if (shippedDateString.toLowerCase().contains(text.toLowerCase())) {
              return true;
            }
            return false;
          }

          return (order.orderId!.toString().contains(text.toLowerCase()) ||
              order.customer!.companyName!
                  .toLowerCase()
                  .contains(text.toLowerCase()) ||
              order.customer!.contactName!
                  .toLowerCase()
                  .contains(text.toLowerCase()) ||
              order.customer!.country!
                  .toLowerCase()
                  .contains(text.toLowerCase()) ||
              order.shipCountry!.toLowerCase().contains(text.toLowerCase()) ||
              orderDateString.toLowerCase().contains(text.toLowerCase()) ||
              shippedDateTest());
        }).toList();
        return newList;
      },
    );
  }
}
