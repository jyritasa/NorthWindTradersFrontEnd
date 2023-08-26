import 'customer_model.dart';
import 'employee_model.dart';
import 'shared/model_class.dart';
import 'order_details_model.dart';
import 'ship_via_navigation_model.dart';

class Order extends Model {
  int? orderId;
  String? customerId;
  int? employeeId;
  String? orderDate;
  String? requiredDate;
  String? shippedDate;
  int? shipVia;
  double? freight;
  String? shipName;
  String? shipAddress;
  String? shipCity;
  String? shipRegion;
  String? shipPostalCode;
  String? shipCountry;
  Customer? customer;
  Employee? employee;
  List<OrderDetails>? orderDetails;
  ShipViaNavigation? shipViaNavigation;

  Order(
      {this.orderId,
      this.customerId,
      this.employeeId,
      this.orderDate,
      this.requiredDate,
      this.shippedDate,
      this.shipVia,
      this.freight,
      this.shipName,
      this.shipAddress,
      this.shipCity,
      this.shipRegion,
      this.shipPostalCode,
      this.shipCountry,
      this.customer,
      this.employee,
      this.orderDetails,
      this.shipViaNavigation});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    customerId = json['customerId'];
    employeeId = json['employeeId'];
    orderDate = json['orderDate'];
    requiredDate = json['requiredDate'];
    shippedDate = json['shippedDate'];
    shipVia = json['shipVia'];
    freight = json['freight'];
    shipName = json['shipName'];
    shipAddress = json['shipAddress'];
    shipCity = json['shipCity'];
    shipRegion = json['shipRegion'];
    shipPostalCode = json['shipPostalCode'];
    shipCountry = json['shipCountry'];
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    employee =
        json['employee'] != null ? Employee.fromJson(json['employee']) : null;
    if (json['orderDetails'] != null) {
      orderDetails = <OrderDetails>[];
      json['orderDetails'].forEach((v) {
        orderDetails!.add(OrderDetails.fromJson(v));
      });
    }
    shipViaNavigation = json['shipViaNavigation'] != null
        ? ShipViaNavigation.fromJson(json['shipViaNavigation'])
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderId'] = orderId;
    data['customerId'] = customerId;
    data['employeeId'] = employeeId;
    data['orderDate'] = orderDate;
    data['requiredDate'] = requiredDate;
    data['shippedDate'] = shippedDate;
    data['shipVia'] = shipVia;
    data['freight'] = freight;
    data['shipName'] = shipName;
    data['shipAddress'] = shipAddress;
    data['shipCity'] = shipCity;
    data['shipRegion'] = shipRegion;
    data['shipPostalCode'] = shipPostalCode;
    data['shipCountry'] = shipCountry;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (employee != null) {
      data['employee'] = employee!.toJson();
    }
    if (orderDetails != null) {
      data['orderDetails'] = orderDetails!.map((v) => v.toJson()).toList();
    }
    if (shipViaNavigation != null) {
      data['shipViaNavigation'] = shipViaNavigation!.toJson();
    }
    return data;
  }
}
