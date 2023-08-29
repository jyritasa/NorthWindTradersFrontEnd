import 'package:northwind/models/shared/model_class.dart';

import 'product_model.dart';

class Supplier extends Model {
  int? supplierId;
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
  String? homePage;
  List<Product>? products;

  Supplier(
      {this.supplierId,
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
      this.homePage,
      this.products});

  Supplier.fromJson(Map<String, dynamic> json) {
    supplierId = json['supplierId'];
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
    homePage = json['homePage'];
    if (json['orders'] != null) {
      products = <Product>[];
      json['orders'].forEach((v) {
        products!.add(Product.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['supplierId'] = supplierId;
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
    data['homePage'] = homePage;
    if (products != null) {
      data['orders'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
