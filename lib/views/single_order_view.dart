import 'package:flutter/material.dart';
import 'package:northwind/components/header.dart';
import 'package:northwind/conf/styles.dart';
import 'package:northwind/models/order_model.dart';

import '../components/orders/orders_breakdown.dart';

//!Note
//OrderDetails.UnitPrice is price of a product in the context of a specific order.
//OrderDetails.Order.UnitPrice is the current standard price.
//Do not get these confused.

class SingleOrderView extends StatefulWidget {
  const SingleOrderView({super.key, required this.order});
  final Order order;

  @override
  State<SingleOrderView> createState() => _SingleOrderViewState();
}

class _SingleOrderViewState extends State<SingleOrderView> {
  DateTime? orderDate;
  DateTime? shippedDate;

  @override
  void initState() {
    super.initState();
    orderDate = DateTime.tryParse(widget.order.orderDate ?? "");
    if (widget.order.shippedDate != null) {
      shippedDate = DateTime.tryParse(widget.order.shippedDate ?? "");
    }
  }

  Widget headerDeliveryIcon() => Padding(
        padding: const EdgeInsets.symmetric(vertical: verticalPadding),
        child: Center(
          child: Icon(
            (shippedDate == null)
                ? Icons.pending_actions
                : Icons.local_shipping_outlined,
            color: (shippedDate == null) ? Colors.red : Colors.green,
            size: 64,
          ),
        ),
      );

  List<Widget> orderInfoSegment() => [
        const NorthWindHeader(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.list_alt),
              Padding(padding: EdgeInsets.only(right: inBetweenPadding)),
              Text(
                "Order Info",
                style: bigStyle,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: orderBreakDownWidget(widget.order),
        ),
      ];

  List<Widget> shippingAddressSegment() => [
        const NorthWindHeader(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.contact_mail),
              Padding(padding: EdgeInsets.only(right: inBetweenPadding)),
              Text("Shipping Address:", style: bigStyle),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.order.shipName ?? "", style: bigStyle),
              Text(widget.order.shipAddress ?? "", style: bigStyle),
              Row(
                children: [
                  Text(widget.order.shipPostalCode ?? "", style: bigStyle),
                  const Padding(
                    padding: EdgeInsets.only(right: inBetweenPadding),
                  ),
                  Text(widget.order.shipCity ?? "", style: bigStyle),
                ],
              ),
              if (widget.order.shipRegion != null)
                Text(widget.order.shipRegion ?? "", style: bigStyle),
              Text(widget.order.shipCountry ?? "", style: bigStyle),
            ],
          ),
        ),
      ];

  List<Widget> shipperInfoSegment() => [
        const NorthWindHeader(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.local_shipping),
              Padding(padding: EdgeInsets.only(right: inBetweenPadding)),
              Text("Shipping Info:", style: bigStyle),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (shippedDate != null)
                Text(
                  "Shipped Date: ${shippedDate?.day}.${shippedDate?.month}.${shippedDate?.year}",
                  style: bigStyle,
                ),
              if (shippedDate == null) const Text("Not Yet Shipped"),
              Text("Shipper: ${widget.order.shipViaNavigation?.companyName}",
                  style: bigStyle),
              Text("Phone: ${widget.order.shipViaNavigation?.phone}",
                  style: bigStyle),
            ],
          ),
        )
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order: ${widget.order.orderId}"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            headerDeliveryIcon(),
            ...orderInfoSegment(),
            ...shippingAddressSegment(),
            if (widget.order.shipViaNavigation != null) ...shipperInfoSegment(),
          ],
        ),
      ),
    );
  }
}
