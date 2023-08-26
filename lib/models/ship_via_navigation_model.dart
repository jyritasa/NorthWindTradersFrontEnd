import 'package:northwind/models/order_model.dart';

class ShipViaNavigation {
  int? shipperId;
  String? companyName;
  String? phone;
  List<Order>? orders;

  ShipViaNavigation(
      {this.shipperId, this.companyName, this.phone, this.orders});

  ShipViaNavigation.fromJson(Map<String, dynamic> json) {
    shipperId = json['shipperId'];
    companyName = json['companyName'];
    phone = json['phone'];
    if (json['orders'] != null) {
      orders = <Order>[];
      json['orders'].forEach((v) {
        orders!.add(Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shipperId'] = shipperId;
    data['companyName'] = companyName;
    data['phone'] = phone;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
