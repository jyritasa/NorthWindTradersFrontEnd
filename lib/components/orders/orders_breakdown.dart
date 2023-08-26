import 'package:flutter/material.dart';
import 'package:northwind/conf/fonts_and_padding.dart';
import 'package:northwind/models/order_model.dart';

String getTotalOrderPrice(Order order) {
  double price = 0;
  for (var od in order.orderDetails!) {
    price += (od.unitPrice! * od.quantity!) -
        (od.unitPrice! * od.quantity! * (od.discount ?? 0));
  }
  price += order.freight ?? 0;
  return "Total: \$${price.toStringAsFixed(2)}";
}

Widget orderBreakDownWidget(Order order) {
  DateTime? orderDate = DateTime.tryParse(order.orderDate ?? "");
  return Column(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (orderDate != null)
            Text(
              "Order Date: ${orderDate.day}.${orderDate.month}.${orderDate.year}",
              style: bigStyle,
            ),
          const Text(
            "Products: ",
            style: bigStyle,
          ),
          const Divider(
            color: Colors.black,
          ),
          if (order.orderDetails != null)
            ...order.orderDetails!.map(
              (od) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${od.product?.productId} ${od.product?.productName}",
                        style: bigStyle,
                      ),
                      Text(
                        "\$${((od.unitPrice! * od.quantity!) - (od.unitPrice! * od.quantity! * (od.discount ?? 0))).toStringAsFixed(2)}",
                        style: bigStyle,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "\$${od.product?.unitPrice}",
                        style: smallStyle,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: inBetweenPadding),
                      ),
                      Text(
                        "x${od.quantity}",
                        style: smallStyle,
                      ),
                    ],
                  ),
                  if (od.discount != null && od.discount != 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Discount: ${od.discount! * 100}%",
                          style: smallStyle,
                        ),
                      ],
                    ),
                  const Divider(
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Shipping: \$${order.freight}",
                style: bigStyle,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                getTotalOrderPrice(order),
                style: bigStyle,
              ),
            ],
          ),
        ],
      ),
    ],
  );
}