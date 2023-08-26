import 'customer_type_model.dart';
import 'shared/model_class.dart';
import 'order_model.dart';

class Customer extends Model {
  String? customerId;
  String? companyName;
  String? contactName;
  String? contactTitle;
  String? address;
  String? city;
  String? region;
  String? postalCode;
  String? country;
  String? phone;
  String? fax;
  List<Order>? orders;
  List<CustomerTypes>? customerTypes;

  Customer(
      {this.customerId,
      this.companyName,
      this.contactName,
      this.contactTitle,
      this.address,
      this.city,
      this.region,
      this.postalCode,
      this.country,
      this.phone,
      this.fax,
      this.orders,
      this.customerTypes});

  Customer.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    companyName = json['companyName'];
    contactName = json['contactName'];
    contactTitle = json['contactTitle'];
    address = json['address'];
    city = json['city'];
    region = json['region'];
    postalCode = json['postalCode'];
    country = json['country'];
    phone = json['phone'];
    fax = json['fax'];
    if (json['orders'] != null) {
      orders = <Order>[];
      json['orders'].forEach((v) {
        orders!.add(Order.fromJson(v));
      });
    }
    if (json['customerTypes'] != null) {
      customerTypes = <CustomerTypes>[];
      json['customerTypes'].forEach((v) {
        customerTypes!.add(CustomerTypes.fromJson(v));
      });
    }
  }

  static Map<String, dynamic> get data => {};

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['companyName'] = companyName;
    data['contactName'] = contactName;
    data['contactTitle'] = contactTitle;
    data['address'] = address;
    data['city'] = city;
    data['region'] = region;
    data['postalCode'] = postalCode;
    data['country'] = country;
    data['phone'] = phone;
    data['fax'] = fax;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    if (customerTypes != null) {
      data['customerTypes'] = customerTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
