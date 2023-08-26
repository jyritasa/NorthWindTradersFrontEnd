import 'product_model.dart';

class OrderDetails {
  int? orderId;
  int? productId;
  double? unitPrice;
  int? quantity;
  double? discount;
  String? order;
  Product? product;

  OrderDetails(
      {this.orderId,
      this.productId,
      this.unitPrice,
      this.quantity,
      this.discount,
      this.order,
      this.product});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    productId = json['productId'];
    unitPrice = json['unitPrice'];
    quantity = json['quantity'];
    discount = json['discount'];
    order = json['order'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderId'] = orderId;
    data['productId'] = productId;
    data['unitPrice'] = unitPrice;
    data['quantity'] = quantity;
    data['discount'] = discount;
    data['order'] = order;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}
