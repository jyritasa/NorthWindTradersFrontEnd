import 'package:northwind/models/territories_model.dart';

class Region {
  int? regionId;
  String? regionDescription;
  List<Territories>? territories;

  Region({this.regionId, this.regionDescription, this.territories});

  Region.fromJson(Map<String, dynamic> json) {
    regionId = json['regionId'];
    regionDescription = json['regionDescription'];
    if (json['orders'] != null) {
      territories = <Territories>[];
      json['orders'].forEach((v) {
        territories!.add(Territories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['regionId'] = regionId;
    data['regionDescription'] = regionDescription;
    if (territories != null) {
      data['orders'] = territories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
