class CustomerTypes {
  String? customerTypeId;
  String? customerDesc;
  List<String>? customers;

  CustomerTypes({this.customerTypeId, this.customerDesc, this.customers});

  CustomerTypes.fromJson(Map<String, dynamic> json) {
    customerTypeId = json['customerTypeId'];
    customerDesc = json['customerDesc'];
    customers = json['customers'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerTypeId'] = customerTypeId;
    data['customerDesc'] = customerDesc;
    data['customers'] = customers;
    return data;
  }
}
