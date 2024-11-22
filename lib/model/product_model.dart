class ProductModel {
  int? productId;
  String? productName, categoryName;
  int qty = 0;
  int? categoryId;
  String? image;
  double? priceIn;
  double? priceOut;
  String? desc;
  int sold = 0;
  double amount = 0;
  bool isFav = false;
  ProductModel({
    this.productId,
    this.productName,
    this.qty = 0,
    this.categoryId,
    this.image,
    this.priceIn,
    this.priceOut,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    qty = json['qty'];
    desc = json['desc'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    if (json['image'] != null && json['image'].isNotEmpty) {
      image = "${json['image']}";
    }

    priceIn = (json['price_in'] ?? 0).toDouble();
    priceOut = (json['price_out'] ?? 0).toDouble();
    isFav = (json['isfav'] ?? 0) == 0 ? false : true;
    sold = json['sold'] ?? 0;
    if (json['amount'] != null) {
      amount = json['amount'].toDouble();
    }
  }
}
