import 'dart:convert';

PaymentReqModel paymentReqModelFromJson(String str) =>
    PaymentReqModel.fromJson(json.decode(str));

String paymentReqModelToJson(PaymentReqModel data) =>
    json.encode(data.toJson());

class PaymentReqModel {
  final int amount;

  PaymentReqModel({
    required this.amount,
  });

  factory PaymentReqModel.fromJson(Map<String, dynamic> json) =>
      PaymentReqModel(
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
      };
}
