// ignore_for_file: public_member_api_docs, sort_constructors_first

const defualtImage =
    'https://firebasestorage.googleapis.com/v0/b/fir-auth-1d214.appspot.com/o/empty.jpg?alt=media&token=34a0ae35-94b2-4007-97cb-e55797ab9257';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String photo = '';
  String? provide;
  bool isActive = true;
  bool isAdmin = false;
  UserModel(
      {this.id,
      this.name,
      this.email,
      this.photo = defualtImage,
      this.provide,
      this.isActive = true,
      this.phone,
      this.isAdmin = false});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    email = json['email'];
    if (json['photo'] != null && json['photo'].isNotEmpty) {
      photo = "${json['photo']}";
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
