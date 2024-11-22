class ReportModel {
  String customerName = "";
  int unit = 0;
  String paymentType = "";
  double amountSale = 0.0;
  String date = '';
  ReportModel.fromJson(Map json) {
    customerName = json['customer_name'] ?? '';
    unit = json['units'] ?? 0;
    paymentType = json['payment_type'] ?? '';
    amountSale = json['amount_sale'] ?? 0.0;
    date = json['date'] ?? '';
  }
}
