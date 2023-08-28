import 'package:flutter/material.dart';
import 'package:northwind/views/shared/view_class.dart';

import '../models/customer_model.dart';
import 'single_order_view.dart';

class CustomersView extends StatelessWidget {
  const CustomersView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ViewFromModel<Customer>(
      fromJson: Customer.fromJson,
      tileTitleWidget: (customer) => Text(customer.contactName ?? ""),
      tileSubTitleWidget: (customer) =>
          Text("${customer.companyName} ${customer.contactTitle}"),
      tileInnerWidget: (customer, models, displayedModels, updateModels) =>
          Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "Address:\n${customer.address ?? ""}\n${customer.postalCode ?? ""} ${customer.city ?? ""}\n${customer.country ?? ""}\n\nPhone: ${customer.phone ?? "N/A"}\nFax: ${customer.fax ?? "N/A"}"),
          if (customer.orders != null)
            const Padding(padding: EdgeInsets.only(top: 5)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Orders:"),
              Wrap(
                children: customer.orders!
                    .map(
                      (order) => TextButton(
                        child: Text(order.orderId.toString()),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SingleOrderView(order: order),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ],
      ),
      searchFilter: (customers, text) {
        var newList = customers
            .where(
              (customer) => (customer.contactName!
                      .toLowerCase()
                      .contains(text.toLowerCase()) ||
                  customer.companyName!
                      .toLowerCase()
                      .contains(text.toLowerCase()) ||
                  customer.contactTitle!
                      .toLowerCase()
                      .contains(text.toLowerCase()) ||
                  customer.country!
                      .toLowerCase()
                      .contains(text.toLowerCase()) ||
                  customer.city!.toLowerCase().contains(text.toLowerCase())),
            )
            .toList();
        return newList;
      },
    );
  }
}
