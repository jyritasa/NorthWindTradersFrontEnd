import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:northwind/models/employee_model.dart';
import 'package:northwind/views/single_order_view.dart';

import './shared/view_class.dart';

class EmplpyeesView extends StatelessWidget {
  const EmplpyeesView({super.key});
  @override
  Widget build(BuildContext context) {
    return ViewFromModel<Employee>(
      fromJson: Employee.fromJson,
      tileTitleWidget: (Employee employee) {
        Uint8List? photoBytes;
        if (employee.photo != null) {
          String photoStr = employee.photo!;
          photoBytes = Uint8List.fromList(base64.decode(photoStr));
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (employee.photo != null && photoBytes != null)
              Image.memory(
                photoBytes,
                width: 200,
              ),
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

/*
class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  late final Future<List<Employee>> _fetchEmployees;
  List<Employee>? employees;
  List<Employee> displayedEmployees = [];

  @override
  void initState() {
    var controller = Controller<Employee>(fromJson: Employee.fromJson);
    _fetchEmployees = controller.getAll();
    super.initState();
  }

  Widget _employeeTile(Employee employee) {
    Uint8List? photoBytes;
    if (employee.photo != null) {
      String photoStr = employee.photo!;
      photoBytes = Uint8List.fromList(base64.decode(photoStr));
    }
    return NorthWindDisplayTile(
      titleWidget: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (employee.photo != null && photoBytes != null)
            Image.memory(
              photoBytes,
              width: 200,
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${employee.firstName} ${employee.lastName}"),
              Text("${employee.title}"),
            ],
          ),
        ],
      ),
      subtitleWidget: Container(),
      innerWidget: Column(
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

  Widget _employeeListView(List<Employee>? customers) => ListView.builder(
        itemCount: customers!.length,
        itemBuilder: (context, index) {
          return _employeeTile(customers[index]);
        },
      );

  Widget _onSnapshotHasDataWidget(snapshot) {
    if (employees == null) {
      employees = snapshot.data ?? [];
      displayedEmployees = employees!;
    }
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: _employeeListView(displayedEmployees),
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
        title: const Text("Employees"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: _fetchEmployees,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Employee>> snapshot) {
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