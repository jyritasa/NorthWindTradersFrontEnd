import 'package:flutter/material.dart';
import 'package:northwind/components/header.dart';
import 'package:northwind/conf/styles.dart';
import 'package:northwind/models/product_model.dart';

class SingleProductView extends StatefulWidget {
  const SingleProductView({super.key, required this.product});
  final Product product;

  @override
  State<SingleProductView> createState() => _SingleProductViewState();
}

class _SingleProductViewState extends State<SingleProductView> {
  List<Widget> productInfo() => [
        const NorthWindHeader(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.fastfood),
              Padding(padding: EdgeInsets.only(right: inBetweenPadding)),
              Text(
                "Product Info",
                style: bigStyle,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Id: ${widget.product.productId}"),
              Text("Name: ${widget.product.productName}"),
              Text("Price: \$${widget.product.unitPrice}"),
              Text("Category: ${widget.product.category?.categoryName}"),
            ],
          ),
        ),
      ];

  List<Widget> storageInformation() => [
        const NorthWindHeader(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart),
              Padding(padding: EdgeInsets.only(right: inBetweenPadding)),
              Text(
                "Storage Info",
                style: bigStyle,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("In Stock: ${widget.product.unitsInStock}"),
              Text("On Order: ${widget.product.unitsOnOrder}"),
              Text(
                  "Stock Value: \$${((widget.product.unitsInStock ?? 0) * (widget.product.unitPrice ?? 0)).toStringAsFixed(2)}"),
            ],
          ),
        ),
      ];

  List<Widget> supplierInfo() => [
        const NorthWindHeader(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.contact_mail),
              Padding(padding: EdgeInsets.only(right: inBetweenPadding)),
              Text(
                "Supplier Info",
                style: bigStyle,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${widget.product.supplier?.companyName}"),
              Text(
                  "Contact Person: ${widget.product.supplier?.contactTitle} ${widget.product.supplier?.contactName}"),
              Text("Phone: ${widget.product.supplier?.phone}"),
              if (widget.product.supplier?.fax != null)
                Text("Name: ${widget.product.supplier?.fax}"),
              if (widget.product.supplier?.homePage != null)
                Text("Home Page: ${widget.product.supplier?.homePage}"),
              const Text("Address: "),
              if (widget.product.supplier?.address != null)
                Text("${widget.product.supplier?.address}"),
              Text(
                  "${widget.product.supplier?.postalCode} ${widget.product.supplier?.city}"),
              Text("${widget.product.supplier?.country}"),
            ],
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Product: ${widget.product.productId} ${widget.product.productName}"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: verticalPadding),
            ),
            ...productInfo(),
            ...storageInformation(),
            ...supplierInfo(),
          ],
        ),
      ),
    );
  }
}
