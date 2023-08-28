import 'product_model.dart';

class OrderDetails {
  int? orderId;
  int? productId;
  double? unitPrice;
  int? quantity;
  double? discount;
  Product? product;

  OrderDetails(
      {this.orderId,
      this.productId,
      this.unitPrice,
      this.quantity,
      this.discount,
      this.product});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    productId = json['productId'];
    unitPrice = json['unitPrice'];
    quantity = json['quantity'];
    discount = json['discount'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orderId != null) data['orderId'] = orderId;
    if (productId != null) data['productId'] = productId;
    if (unitPrice != null) data['unitPrice'] = unitPrice;
    if (quantity != null) data['quantity'] = quantity;
    if (discount != null) data['discount'] = discount;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}
