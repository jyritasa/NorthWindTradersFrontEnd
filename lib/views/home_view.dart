import 'package:flutter/material.dart';
import 'package:northwind/conf/fonts_and_padding.dart';
import 'package:northwind/views/customers_view.dart';
import 'package:northwind/views/employees_view.dart';
import 'package:northwind/views/orders_view.dart';
import 'package:northwind/views/products_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Widget menuButton(
          BuildContext context, Widget view, IconData icon, String title) =>
      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        child: SizedBox(
          width: 300,
          child: ElevatedButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => view,
                    ),
                  ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    size: 32,
                  ),
                  Text(
                    title,
                    style: TextStyle(fontSize: 32),
                  ),
                ],
              )),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("./assets/img/wind-rose.png"),
            Text(
              "NORTHWIND TRADERS",
              style: TextStyle(fontSize: 24, color: Colors.lightBlue),
            ),
            Padding(padding: EdgeInsets.only(bottom: verticalPadding)),
            menuButton(
                context, const CustomersView(), Icons.people, "Customers"),
            menuButton(context, const EmplpyeesView(),
                Icons.person_pin_outlined, "Employees"),
            menuButton(
                context, const ProductsView(), Icons.fastfood, "Products"),
            menuButton(
                context, const OrdersView(), Icons.folder_open, "Orders"),
          ],
        ),
      ),
    );
  }
}