import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:northwind/components/header.dart';
import 'package:northwind/conf/fonts_and_padding.dart';
import 'package:northwind/conf/logger.dart';
import 'package:northwind/controllers/controller_class.dart';
import 'package:northwind/models/customer_model.dart';
import 'package:northwind/models/employee_model.dart';
import 'package:northwind/models/order_model.dart';
import 'package:northwind/models/order_details_model.dart';
import 'package:northwind/models/product_model.dart';

class PostOrderView extends StatefulWidget {
  const PostOrderView({super.key});

  @override
  State<PostOrderView> createState() => _PostOrderViewState();
}

class _PostOrderViewState extends State<PostOrderView> {
  //! Model Controllers
  final Controller<Order> _ordersController = Controller<Order>(
    fromJson: Order.fromJson,
  );
  final Controller<Customer> _customerController = Controller<Customer>(
    fromJson: Customer.fromJson,
  );
  final Controller<Employee> _employeeController = Controller<Employee>(
    fromJson: Employee.fromJson,
  );
  final Controller<Product> _productController = Controller<Product>(
    fromJson: Product.fromJson,
  );

  //! Text Editing Controllers
  final TextEditingController _shipAddressController = TextEditingController();
  final TextEditingController _shipCityController = TextEditingController();
  final TextEditingController _shipPostalCodeController =
      TextEditingController();
  final TextEditingController _shipCountryController = TextEditingController();

  //! Models from Database
  List<Customer> _customers = [];
  List<Employee> _employees = [];
  List<Product> _products = [];
  List<Order> _orders = [];

  //! Fields for Posting the Order into Database
  Customer? currentCustomer;
  Employee? currentEmployee;
  List<OrderDetails> _orderDetails = [];
  int orderId = 0;
  //For FutureBuilder to work it requires something to be returned. Future<void> wont work.
  Future<List> _getAllModels() async {
    _customers = await _customerController.getAll();
    logger.d("Got all Customers");
    _employees = await _employeeController.getAll();
    logger.d("Got all Employees");
    _products = await _productController.getAll();
    logger.d("Got all Products");
    _orders = await _ordersController.getAll();
    if (_orders.isNotEmpty) {
      orderId = _orders
              .map((order) => order.orderId)
              .reduce((a, b) => a! > b! ? a : b) ??
          0;
    }

    return _customers;
  }

  Future<Order?> _postOrder() async {
    logger.i("posting Orders....");
    //? TODO: Cool Validation Here...
    String formattedOrderDate = DateTime.now().toIso8601String();
    logger.d(formattedOrderDate);
    //We dont want to send product info.
    List<OrderDetails> newOrderDetails = _orderDetails;

    //Customer? customer =
    //    await _customerController.getByID(currentCustomer!.customerId);
    //Employee? employee =
    //  await _employeeController.getByID(currentEmployee!.employeeId);

    for (var detail in newOrderDetails) {
      detail.product = null;
    }
    Order order = Order(
      orderId: orderId + 1,
      orderDate: formattedOrderDate,
      //employee: employee,
      //customer: customer,
      customerId: currentCustomer!.customerId,
      employeeId: currentEmployee!.employeeId,
      shipAddress: _shipAddressController.text,
      shipPostalCode: _shipPostalCodeController.text,
      shipCity: _shipCityController.text,
      shipCountry: _shipCountryController.text,
      orderDetails: newOrderDetails,
    );
    return _ordersController.post(order);
  }

  double getOrderTotal() {
    if (_orderDetails.isEmpty) return 0;
    double total = 0;
    for (OrderDetails order in _orderDetails) {
      total += (order.unitPrice! * order.quantity!) -
          (order.unitPrice! * order.quantity! * (order.discount ?? 0));
    }
    return total;
  }

  late final Future _future;

  @override
  void initState() {
    _future = _getAllModels();
    super.initState();
  }

  @override
  void dispose() {
    _shipAddressController.dispose();
    _shipCityController.dispose();
    _shipPostalCodeController.dispose();
    _shipCountryController.dispose();
    super.dispose();
  }

  List<Widget> basicInfoSections() => [
        const NorthWindHeader(child: Text("Basic Information")),
        Row(
          children: [
            const Text("Customer: "),
            const Padding(padding: EdgeInsets.only(right: inBetweenPadding)),
            DropdownMenu<Customer?>(
              menuHeight: 800,
              initialSelection: null,
              onSelected: (Customer? value) {
                setState(() {
                  currentCustomer = value!;
                });
              },
              dropdownMenuEntries: _customers.map<DropdownMenuEntry<Customer?>>(
                (Customer? value) {
                  return DropdownMenuEntry<Customer?>(
                      value: value, label: value?.companyName ?? "");
                },
              ).toList(),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(bottom: inBetweenPadding)),
        Row(
          children: [
            const Text("Employee: "),
            const Padding(padding: EdgeInsets.only(right: inBetweenPadding)),
            DropdownMenu<Employee?>(
              initialSelection: null,
              onSelected: (Employee? value) {
                setState(() {
                  currentEmployee = value!;
                });
              },
              dropdownMenuEntries: _employees.map<DropdownMenuEntry<Employee?>>(
                (Employee? value) {
                  return DropdownMenuEntry<Employee?>(
                      value: value,
                      label: "${value?.firstName} ${value?.lastName}");
                },
              ).toList(),
            ),
          ],
        ),
        TextField(
          controller: _shipAddressController,
          decoration: const InputDecoration(labelText: "Ship Address"),
        ),
        const Padding(padding: EdgeInsets.only(bottom: inBetweenPadding)),
        TextField(
          controller: _shipCityController,
          decoration: const InputDecoration(labelText: "Ship City"),
        ),
        const Padding(padding: EdgeInsets.only(bottom: inBetweenPadding)),
        TextField(
          controller: _shipPostalCodeController,
          decoration: const InputDecoration(labelText: "Ship Postal Code"),
        ),
        const Padding(padding: EdgeInsets.only(bottom: inBetweenPadding)),
        TextField(
          controller: _shipCountryController,
          decoration: const InputDecoration(labelText: "Ship Country"),
        ),
      ];

  List<Widget> orderDetailsSection() => [
        const NorthWindHeader(child: Text("Products")),
        const Padding(padding: EdgeInsets.only(right: inBetweenPadding)),
        Row(
          children: [
            const Text("Select Product:"),
            const Padding(padding: EdgeInsets.only(right: inBetweenPadding)),
            Flexible(
              child: DropdownMenu<Product?>(
                menuHeight: 400,
                initialSelection: null,
                onSelected: (Product? value) {
                  setState(() {
                    if (value != null) {
                      _orderDetails.add(
                        OrderDetails(
                          productId: value.productId,
                          unitPrice: value.unitPrice,
                          quantity: 1,
                          discount: 0,
                          product: value,
                        ),
                      );
                    }
                  });
                },
                dropdownMenuEntries: _products.map<DropdownMenuEntry<Product?>>(
                  (Product? value) {
                    return DropdownMenuEntry<Product?>(
                        value: value,
                        label: "${value?.productId} ${value?.productName}");
                  },
                ).toList(),
              ),
            ),
          ],
        ),
        ..._orderDetails
            .asMap()
            .entries
            .map(
              (details) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Text(details.value.product!.productName ?? ""),
                  Text("\$${details.value.unitPrice}"),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              //Dart being Dart...
                              _orderDetails[details.key].quantity =
                                  _orderDetails[details.key].quantity! + 1;
                            });
                          },
                          icon: const Icon(Icons.add_box_outlined)),
                      Text("${details.value.quantity}"),
                      IconButton(
                        onPressed: () => setState(() {
                          if (details.value.quantity != 0) {
                            if (_orderDetails[details.key].quantity! > 0) {
                              _orderDetails[details.key].quantity =
                                  _orderDetails[details.key].quantity! - 1;
                            }
                          }
                        }),
                        icon:
                            const Icon(Icons.indeterminate_check_box_outlined),
                      ),
                    ],
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Discount (%)',
                      hintText: 'Enter discount percentage',
                    ),
                    onChanged: (value) {
                      // Validate and update the discount value
                      if (value.isEmpty || double.tryParse(value) == null) {
                        // Invalid input
                        setState(() {
                          _orderDetails[details.key].discount = 0;
                        });
                      } else {
                        double sentValue = double.parse(value) / 100;
                        setState(() {
                          if (sentValue >= 0 && sentValue <= 1) {
                            _orderDetails[details.key].discount = sentValue;
                          }
                        });
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _orderDetails.removeAt(details.key);
                    }),
                    child: const Row(
                      children: [
                        Text("Remove"),
                        Icon(Icons.delete_outline_outlined),
                      ],
                    ),
                  )
                ],
              ),
            )
            .toList(),
        if (_orderDetails.isNotEmpty) ...[
          const Divider(),
          Text("Total: \$${getOrderTotal()}"),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _orderDetails = [];
              });
            },
            child: const Text("Empty Products"),
          )
        ]
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit New Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: _future,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...basicInfoSections(),
                        ...orderDetailsSection(),
                        ElevatedButton(
                            onPressed: () async => _postOrder(),
                            child: Text("post!"))
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return const CupertinoActivityIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
