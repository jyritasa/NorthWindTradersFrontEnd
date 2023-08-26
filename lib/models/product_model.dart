import 'package:northwind/models/order_details_model.dart';
import 'package:northwind/models/shared/model_class.dart';

import 'category_model.dart';
import 'supplier_model.dart';

class Product extends Model {
  int? productId;
  String? productName;
  int? supplierId;
  int? categoryId;
  String? quantityPerUnit;
  double? unitPrice;
  int? unitsInStock;
  int? unitsOnOrder;
  int? reorderLevel;
  bool? discontinued;
  Category? category;
  List<OrderDetails>? orderDetails;
  Supplier? supplier;

  Product(
      {this.productId,
      this.productName,
      this.supplierId,
      this.categoryId,
      this.quantityPerUnit,
      this.unitPrice,
      this.unitsInStock,
      this.unitsOnOrder,
      this.reorderLevel,
      this.discontinued,
      this.category,
      this.orderDetails,
      this.supplier});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    supplierId = json['supplierId'];
    categoryId = json['categoryId'];
    quantityPerUnit = json['quantityPerUnit'];
    unitPrice = json['unitPrice'];
    unitsInStock = json['unitsInStock'];
    unitsOnOrder = json['unitsOnOrder'];
    reorderLevel = json['reorderLevel'];
    discontinued = json['discontinued'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    if (json['orders'] != null) {
      orderDetails = <OrderDetails>[];
      json['orders'].forEach((v) {
        orderDetails!.add(OrderDetails.fromJson(v));
      });
    }
    supplier =
        json['supplier'] != null ? Supplier.fromJson(json['supplier']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['productName'] = productName;
    data['supplierId'] = supplierId;
    data['categoryId'] = categoryId;
    data['quantityPerUnit'] = quantityPerUnit;
    data['unitPrice'] = unitPrice;
    data['unitsInStock'] = unitsInStock;
    data['unitsOnOrder'] = unitsOnOrder;
    data['reorderLevel'] = reorderLevel;
    data['discontinued'] = discontinued;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (orderDetails != null) {
      data['orders'] = orderDetails!.map((v) => v.toJson()).toList();
    }
    if (supplier != null) {
      data['supplier'] = supplier!.toJson();
    }
    return data;
  }
}
