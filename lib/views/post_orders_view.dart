import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:northwind/components/activity_indicator.dart';
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
  final TextEditingController _freightController = TextEditingController();

  //! Models from Database
  List<Customer> _customers = [];
  List<Employee> _employees = [];
  List<Product> _products = [];

  //! Fields for Posting the Order into Database
  Customer? currentCustomer;
  Employee? currentEmployee;
  List<OrderDetails> _orderDetails = [];
  double? _freight = 0;
  //For FutureBuilder to work it requires something to be returned. Future<void> wont work.
  Future<List> _getAllModels() async {
    _customers = await _customerController.getMinimal();
    if (kDebugMode) logger.d("Got all Customers");
    _employees = await _employeeController.getMinimal();
    if (kDebugMode) logger.d("Got all Employees");
    _products = await _productController.getMinimal();
    if (kDebugMode) logger.d("Got all Products");
    return _products;
  }

  Future<Order?> _postOrder() async {
    //? TODO: Cool Validation Here...

    logger.i("posting Orders....");

    String formattedOrderDate = DateTime.now().toIso8601String();
    logger.d(formattedOrderDate);
    //We dont want to send product info.
    List<OrderDetails> newOrderDetails = _orderDetails;
    for (var detail in newOrderDetails) {
      detail.product = null;
    }

    Order order = Order(
      orderDate: DateTime.now().toIso8601String(),
      customerId: currentCustomer!.customerId,
      employeeId: currentEmployee!.employeeId,
      shipAddress: _shipAddressController.text,
      shipPostalCode: _shipPostalCodeController.text,
      shipCity: _shipCityController.text,
      shipCountry: _shipCountryController.text,
      orderDetails: newOrderDetails,
      freight: _freight,
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
    total += _freight ?? 0;
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
    _freightController.dispose();

    super.dispose();
  }

  List<Widget> basicInfoSections() => [
        const NorthWindHeader(
            child: Text(
          "Basic Information",
          style: bigStyle,
        )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: inBetweenPadding)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Customer: ",
                    style: bigStyle,
                  ),
                  DropdownMenu<Customer?>(
                    menuHeight: 800,
                    initialSelection: null,
                    onSelected: (Customer? value) {
                      setState(() {
                        currentCustomer = value!;
                      });
                    },
                    dropdownMenuEntries:
                        _customers.map<DropdownMenuEntry<Customer?>>(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Employee: ",
                    style: bigStyle,
                  ),
                  DropdownMenu<Employee?>(
                    initialSelection: null,
                    onSelected: (Employee? value) {
                      setState(() {
                        currentEmployee = value!;
                      });
                    },
                    dropdownMenuEntries:
                        _employees.map<DropdownMenuEntry<Employee?>>(
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
                decoration:
                    const InputDecoration(labelText: "Ship Postal Code"),
              ),
              const Padding(padding: EdgeInsets.only(bottom: inBetweenPadding)),
              TextField(
                controller: _shipCountryController,
                decoration: const InputDecoration(labelText: "Ship Country"),
              ),
            ],
          ),
        ),
      ];

  List<Widget> orderDetailsSection() => [
        const Padding(padding: EdgeInsets.only(top: inBetweenPadding)),
        const NorthWindHeader(
            child: Text(
          "Products",
          style: bigStyle,
        )),
        const Padding(padding: EdgeInsets.only(top: inBetweenPadding)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Product:",
                    style: bigStyle,
                  ),
                  Flexible(
                    child: DropdownMenu<Product?>(
                      menuHeight: 400,
                      width: 300,
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
                      dropdownMenuEntries:
                          _products.map<DropdownMenuEntry<Product?>>(
                        (Product? value) {
                          return DropdownMenuEntry<Product?>(
                              value: value,
                              label:
                                  "${value?.productId} ${value?.productName}");
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
              ..._orderDetails.asMap().entries.map(
                (details) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      Text(details.value.product!.productName ?? ""),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("\$${details.value.unitPrice}",
                                  style: const TextStyle(fontSize: 16)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () => setState(() {
                                      if (details.value.quantity != 0) {
                                        if (_orderDetails[details.key]
                                                .quantity! >
                                            0) {
                                          _orderDetails[details.key].quantity =
                                              _orderDetails[details.key]
                                                      .quantity! -
                                                  1;
                                        }
                                      }
                                    }),
                                    icon: const Icon(
                                        Icons.indeterminate_check_box_outlined),
                                  ),
                                  Text(
                                    "${details.value.quantity}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        //Dart being Dart...
                                        _orderDetails[details.key].quantity =
                                            _orderDetails[details.key]
                                                    .quantity! +
                                                1;
                                      });
                                    },
                                    icon: const Icon(Icons.add_box_outlined),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 135,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Discount (%)',
                                      hintText: 'Enter discount %',
                                    ),
                                    onChanged: (value) {
                                      // Validate and update the discount value
                                      if (value.isEmpty ||
                                          double.tryParse(value) == null) {
                                        // Invalid input
                                        setState(() {
                                          _orderDetails[details.key].discount =
                                              0;
                                        });
                                      } else {
                                        double sentValue =
                                            double.parse(value) / 100;
                                        setState(() {
                                          if (sentValue >= 0 &&
                                              sentValue <= 1) {
                                            _orderDetails[details.key]
                                                .discount = sentValue;
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                              "\$${((details.value.unitPrice! * details.value.quantity!) + (details.value.unitPrice! * details.value.discount!)).toStringAsFixed(2)}",
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 125,
                          child: ElevatedButton(
                            onPressed: () => setState(() {
                              _orderDetails.removeAt(details.key);
                            }),
                            child: const Row(
                              children: [
                                Text("Remove"),
                                Icon(Icons.delete_outline_outlined),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ).toList(),
              if (_orderDetails.isNotEmpty) ...[
                const Divider(),
                SizedBox(
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextFormField(
                      controller: _freightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Freight (\$)',
                        hintText: 'Enter Freight \$',
                      ),
                      onChanged: (value) {
                        if (value == "") value = "0";
                        _freight = double.parse(value);
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Total: \$${getOrderTotal().toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _orderDetails = [];
                    });
                  },
                  child: const Text("Empty Products"),
                )
              ],
            ],
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Submit New Order'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FutureBuilder(
                future: _future,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(top: inBetweenPadding)),
                        ...basicInfoSections(),
                        ...orderDetailsSection(),
                        const Padding(
                            padding: EdgeInsets.only(top: inBetweenPadding)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  final value = await _postOrder();
                                  if (value != null) {
                                    Navigator.pop(context);
                                  } else {
                                    if (kDebugMode) {
                                      logger.e(
                                          "_PostOrder failed, not Popping View");
                                    }
                                  }
                                },
                                child: const Text("Send"),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return NorthWindActivityIndicator();
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
