// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:homework3/model/imagemodel.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  ImageModel photo = ImageModel.instance;
  String? provide;
  bool isActive = true;
  bool isAdmin = false;
  UserModel(
      {this.id,
      this.name,
      this.email,
      this.provide,
      this.isActive = true,
      this.phone,
      this.isAdmin = false});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    email = json['email'];
    if (json['photo'] != null && json['photo'].isNotEmpty) {
      photo = ImageModel.fromNetwork(json['photo'] ?? '');
    }
    phone = json['phone'];
    isActive = json['active'] ?? true;
    isAdmin = json['is_admin'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['proide'] = provide;
    data['email'] = email;
    data['photo'] = photo;
    return data;
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, photo: $photo, provide: $provide)';
  }
}
