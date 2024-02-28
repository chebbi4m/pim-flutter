import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/request/payment_req.dart';
import 'package:flutter_application_1/models/response/payment_res.dart';
import 'package:flutter_application_1/services/helpers/payment_helper.dart';

class PaymentNotifier extends ChangeNotifier {
  late Future<PaymentResModel> paymentResult;

  makePayment(int amount) {
    paymentResult = PaymentHelper.makePayment(amount);
  }
}
