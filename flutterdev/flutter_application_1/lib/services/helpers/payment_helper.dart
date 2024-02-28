import 'dart:convert';
import 'dart:developer';
import 'package:flutter_application_1/models/request/payment_req.dart';
import 'package:flutter_application_1/models/response/payment_res.dart';
import 'package:flutter_application_1/services/config.dart';
import 'package:http/http.dart' as https;

class PaymentHelper {
  static var client = https.Client();

  static Future<PaymentResModel> makePayment(int amount) async {
    // Create a PaymentReqModel object with the provided amount
    var paymentReq = PaymentReqModel(amount: amount);

    // Serialize the PaymentReqModel to JSON
    var requestBody = paymentReqModelToJson(paymentReq);

    // Log the JSON data to be sent in the request body
    print('Request Body: $requestBody');

    // Define the request headers
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };

    // Construct the URL
    var url = Uri.http(Config.apiUrl, Config.paymentUrl);

    // Make the POST request with the serialized request body and headers
    var response =
        await client.post(url, headers: requestHeaders, body: requestBody);
    print(url);

    if (response.statusCode == 200) {
      var paymentRes = paymentResModelFromJson(response.body);
      print(paymentRes.result.link);
      return paymentRes;
    } else {
      throw Exception("Failed to make payment");
    }
  }
}
