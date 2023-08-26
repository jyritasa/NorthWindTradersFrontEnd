import 'package:flutter/material.dart';
import 'package:northwind/views/shared/view_class.dart';

import '../models/customer_model.dart';
import 'single_order_view.dart';

class CustomersView extends StatelessWidget {
  const CustomersView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewFromModel<Customer>(
      fromJson: Customer.fromJson,
      tileTitleWidget: (customer) => Text(customer.contactName ?? ""),
      tileSubTitleWidget: (customer) =>
          Text("${customer.companyName} ${customer.contactTitle}"),
      tileInnerWidget: (customer) => Column(
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
              ...customer.orders!
                  .map(
                    (order) => TextButton(
                      child: Text(order.orderId.toString()),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleOrderView(order: order),
                          ),
                        );
                      },
                    ),
                  )
                  .toList(),
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

/*
@immutable
class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  ///Future for getting all [Customer]s from the backend. Initialized in the [initState] method so it's not called again when state changes.
  late final Future<List<Customer>> _fetchCustomers;

  ///List of all [Customer]s saved. Afer initialization in the [build] List stays unchanged.
  List<Customer>? customers;

  ///List of all [Customer]s displayed on [_customerListView]. Uses [customers] as a base and is Manipulated by [_searchBar].
  List<Customer> displayedCustomers = [];

  @override
  void initState() {
    super.initState();
    var controller = Controller<Customer>(fromJson: Customer.fromJson);
    _fetchCustomers = controller.getAll();
  }

  Widget _customerTile(Customer customer) => NorthWindDisplayTile(
        titleWidget: Text(customer.contactName ?? ""),
        subtitleWidget:
            Text("${customer.companyName} ${customer.contactTitle}"),
        innerWidget: Column(
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
                ...customer.orders!
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
              ],
            ),
          ],
        ),
      );

  ///[ListView] generated from list of [Customer]s from [displayedCustomers].
  Widget _customerListView(List<Customer>? customers) => ListView.builder(
        itemCount: customers!.length,
        itemBuilder: (context, index) {
          return _customerTile(customers[index]);
        },
      );

  ///[SearchAnchor] for filtering [_customerListView]'s [Customer]s based on name, company, title, country and city.
  Widget _searchBar() => NorthWindSearchBar(
        onChanged: (text) {
          var newList = customers!
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
          setState(() {
            displayedCustomers = newList;
          });
        },
      );

  Widget _onSnapshotHasDataWidget(snapshot) {
    if (customers == null) {
      customers = snapshot.data ?? [];
      displayedCustomers = customers!;
    }
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: _searchBar(),
            ),
          ),
          Expanded(
            child: _customerListView(displayedCustomers),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Customers"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: _fetchCustomers,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Customer>> snapshot) {
                if (snapshot.hasData) {
                  return _onSnapshotHasDataWidget(snapshot);
                } else if (snapshot.hasError) {
                  //! TODO: Proper Error Handling
                  return Text("Error: ${snapshot.error}");
                } else {
                  return CupertinoActivityIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    radius: 32,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
*/