class Address {
  String? receiverName;
  String? ph;
  String? province;
  String? district;
  String? commune;
  String? house;
  double latitude = 0;
  double longitude = 0;
  Address({
    this.receiverName,
    this.ph,
    this.province,
    this.district,
    this.commune,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.house,
  });
}
