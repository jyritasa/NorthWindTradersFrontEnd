import 'package:northwind/models/territories_model.dart';

import 'order_model.dart';
import 'shared/model_class.dart';

class Employee extends Model {
  int? employeeId;
  String? lastName;
  String? firstName;
  String? title;
  String? titleOfCourtesy;
  String? birthDate;
  String? hireDate;
  String? address;
  String? city;
  String? region;
  String? postalCode;
  String? country;
  String? homePhone;
  String? extension;
  String? photo;
  String? notes;
  int? reportsTo;
  String? photoPath;
  List<Employee>? inverseReportsToNavigation;
  List<Order>? orders;
  Employee? reportsToNavigation;
  List<Territories>? territories;

  Employee(
      {this.employeeId,
      this.lastName,
      this.firstName,
      this.title,
      this.titleOfCourtesy,
      this.birthDate,
      this.hireDate,
      this.address,
      this.city,
      this.region,
      this.postalCode,
      this.country,
      this.homePhone,
      this.extension,
      this.photo,
      this.notes,
      this.reportsTo,
      this.photoPath,
      this.inverseReportsToNavigation,
      this.orders,
      this.reportsToNavigation,
      this.territories});

  Employee.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    lastName = json['lastName'];
    firstName = json['firstName'];
    title = json['title'];
    titleOfCourtesy = json['titleOfCourtesy'];
    birthDate = json['birthDate'];
    hireDate = json['hireDate'];
    address = json['address'];
    city = json['city'];
    region = json['region'];
    postalCode = json['postalCode'];
    country = json['country'];
    homePhone = json['homePhone'];
    extension = json['extension'];
    photo = json['photo'];
    notes = json['notes'];
    reportsToNavigation =
        json['employee'] != null ? Employee.fromJson(json['employee']) : null;
    photoPath = json['photoPath'];
    if (json['inverseReportsToNavigation'] != null) {
      inverseReportsToNavigation = <Employee>[];
      json['inverseReportsToNavigation'].forEach((v) {
        inverseReportsToNavigation!.add(Employee.fromJson(v));
      });
    }
    if (json['orders'] != null) {
      orders = <Order>[];
      json['orders'].forEach((v) {
        orders!.add(Order.fromJson(v));
      });
    }
    reportsToNavigation = json['reportsToNavigation'];
    if (json['territories'] != null) {
      territories = <Territories>[];
      json['territories'].forEach((v) {
        territories!.add(Territories.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employeeId'] = employeeId;
    data['lastName'] = lastName;
    data['firstName'] = firstName;
    data['title'] = title;
    data['titleOfCourtesy'] = titleOfCourtesy;
    data['birthDate'] = birthDate;
    data['hireDate'] = hireDate;
    data['address'] = address;
    data['city'] = city;
    data['region'] = region;
    data['postalCode'] = postalCode;
    data['country'] = country;
    data['homePhone'] = homePhone;
    data['extension'] = extension;
    data['photo'] = photo;
    data['notes'] = notes;
    data['reportsTo'] = reportsTo;
    data['photoPath'] = photoPath;
    if (inverseReportsToNavigation != null) {
      data['inverseReportsToNavigation'] =
          inverseReportsToNavigation!.map((v) => v.toJson()).toList();
    }
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    if (reportsToNavigation != null) {
      data['reportsToNavigation'] = reportsToNavigation!.toJson();
    }
    if (territories != null) {
      data['territories'] = territories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
