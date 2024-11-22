class AddressModel {
  int? id;
  String? customerId;
  String? receiverName;
  String? phoneNumber;
  String? province;
  String? district;
  String? commune;
  String? house;

  AddressModel(
      {this.id,
      this.customerId,
      this.receiverName,
      this.phoneNumber,
      this.province,
      this.district,
      this.commune,
      this.house});

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = (json['customer_id'] ?? 0).toString();
    receiverName = json['receiver_name'];
    phoneNumber = json['phone_number'];
    province = json['province'];
    district = json['district'];
    commune = json['commune'];
    house = json['house'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['receiver_name'] = receiverName;
    data['phone_number'] = phoneNumber;
    data['province'] = province;
    data['district'] = district;
    data['commune'] = commune;
    data['house'] = house;
    return data;
  }
}
