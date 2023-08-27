import 'package:flutter/material.dart';
import 'package:northwind/components/string_to_photo.dart';
import 'package:northwind/conf/fonts_and_padding.dart';
import 'package:northwind/models/product_model.dart';
import 'package:northwind/views/shared/view_class.dart';
import 'package:northwind/views/single_product_view.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewFromModel<Product>(
      fromJson: Product.fromJson,
      tileTitleWidget: (product) => Row(
        children: [
          if (product.category?.picture != null) ...[
            photoFromString(product.category!.picture!, 50),
            const Padding(
              padding: EdgeInsets.only(right: inBetweenPadding),
            ),
          ],
          Expanded(child: Text(product.productName ?? "")),
          Flexible(
            child: Container(),
          ),
          Expanded(
            child: ElevatedButton(
              child: const Text("Open"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SingleProductView(product: product),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      tileSubTitleWidget: (product) => Text(
          "${product.category?.categoryName} ${product.supplier?.companyName}"),
      searchFilter: (products, text) {
        var newList = products.where((product) {
          return (product.productId!.toString().contains(text.toLowerCase()) ||
              product.productId!
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()) ||
              product.productName!.toLowerCase().contains(text.toLowerCase()) ||
              product.category!.categoryName!
                  .toLowerCase()
                  .contains(text.toLowerCase()) ||
              product.supplier!.companyName!
                  .toLowerCase()
                  .contains(text.toLowerCase()) ||
              product.supplier!.country!
                  .toLowerCase()
                  .contains(text.toLowerCase()));
        }).toList();
        return newList;
      },
    );
  }
}
