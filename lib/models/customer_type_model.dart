import 'package:northwind/models/shared/model_class.dart';

class CustomerTypes extends Model {
  String? customerTypeId;
  String? customerDesc;
  List<String>? customers;

  CustomerTypes({this.customerTypeId, this.customerDesc, this.customers});

  CustomerTypes.fromJson(Map<String, dynamic> json) {
    customerTypeId = json['customerTypeId'];
    customerDesc = json['customerDesc'];
    customers = json['customers'].cast<String>();
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerTypeId'] = customerTypeId;
    data['customerDesc'] = customerDesc;
    data['customers'] = customers;
    return data;
  }
}
