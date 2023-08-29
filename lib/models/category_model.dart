import 'package:northwind/models/shared/model_class.dart';

import 'product_model.dart';

class Category extends Model {
  int? categoryId;
  String? categoryName;
  String? description;
  String? picture;
  List<Product>? products;

  Category(
      {this.categoryId,
      this.categoryName,
      this.description,
      this.picture,
      this.products});

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    description = json['description'];
    picture = json['picture'];
    if (json['products'] != null) {
      products = <Product>[];
      json['orders'].forEach((v) {
        products!.add(Product.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryId'] = categoryId;
    data['categoryName'] = categoryName;
    data['description'] = description;
    data['picture'] = picture;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
