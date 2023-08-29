import 'package:northwind/models/shared/model_class.dart';

import 'employee_model.dart';
import 'region_model.dart';

class Territories extends Model {
  String? territoryId;
  String? territoryDescription;
  int? regionId;
  Region? region;
  List<Employee>? employees;

  Territories(
      {this.territoryId,
      this.territoryDescription,
      this.regionId,
      this.region,
      this.employees});

  Territories.fromJson(Map<String, dynamic> json) {
    territoryId = json['territoryId'];
    territoryDescription = json['territoryDescription'];
    regionId = json['regionId'];
    region = json['region'] != null ? Region.fromJson(json['region']) : null;
    if (json['customerTypes'] != null) {
      employees = <Employee>[];
      json['customerTypes'].forEach((v) {
        employees!.add(Employee.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['territoryId'] = territoryId;
    data['territoryDescription'] = territoryDescription;
    data['regionId'] = regionId;
    if (region != null) {
      data['region'] = region!.toJson();
    }
    if (employees != null) {
      data['orders'] = employees!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
