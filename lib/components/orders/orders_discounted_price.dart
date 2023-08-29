import '../../models/order_details_model.dart';

double discountedPrice(double unitPrice, int quantity, double discount) =>
    ((unitPrice * quantity) - (unitPrice * quantity * discount));

double getTotalOrderPrice(List<OrderDetails> orderDetails, double freight) {
  if (orderDetails.isEmpty) return 0;
  double price = 0;
  for (var od in orderDetails) {
    price +=
        discountedPrice(od.unitPrice ?? 0, od.quantity ?? 1, od.discount ?? 0);
  }
  price += freight;
  return price;
}
