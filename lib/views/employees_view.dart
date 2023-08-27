import 'package:flutter/material.dart';
import 'package:northwind/models/employee_model.dart';
import 'package:northwind/views/single_order_view.dart';

import '../components/string_to_photo.dart';
import './shared/view_class.dart';

class EmplpyeesView extends StatelessWidget {
  const EmplpyeesView({super.key});
  @override
  Widget build(BuildContext context) {
    return ViewFromModel<Employee>(
      fromJson: Employee.fromJson,
      tileTitleWidget: (Employee employee) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (employee.photo != null) photoFromString(employee.photo!, 200),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${employee.firstName} ${employee.lastName}"),
                Text("${employee.title}"),
              ],
            ),
          ],
        );
      },
      tileInnerWidget: (Employee employee) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Orders:"),
          Wrap(
            children: employee.orders!
                .map(
                  (order) => TextButton(
                    child: Text(order.orderId.toString()),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SingleOrderView(order: order)),
                      );
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
