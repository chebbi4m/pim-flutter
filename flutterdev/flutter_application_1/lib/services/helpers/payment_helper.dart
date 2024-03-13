import 'package:flutter_application_1/models/request/payment_req.dart';
import 'package:flutter_application_1/models/response/payment_res.dart';
import 'package:flutter_application_1/services/config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as https;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PaymentHelper {
  final storage = FlutterSecureStorage();
  static var client = https.Client();

  static Future<PaymentResModel> makePayment(int amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    // Create a PaymentReqModel object with the provided amount
    var paymentReq = PaymentReqModel(amount: amount, userId: userId!);

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

  Future<void> transfertochild(int amount, String childusername) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    print(childusername);

   String? encrypted =  await prefs.getString('encrypted');
     String? ivv = await prefs.getString('iv');
    final url = Uri.parse(
        'http://10.0.2.2:9090/api/payment/transfertochild'); // Replace with your create child endpoint
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'amount': amount,
      'parentid': userId,
      'cryptedkey': encrypted,
      'childusername': childusername,
      'iv': ivv
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responsedata = jsonDecode(response.body);

// Write value

        /*await storage.write(
            key: "iv:${childusername}",
            value: responsedata["iv"],
            aOptions: _getAndroidOptions());*/

        print(
            'Child created successfully his private key crypted is :');
      } else {
        print('Failed to create child: ${response.body}');
      }
    } catch (error) {
      print('Error creating child: $error');
    }
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
        // sharedPreferencesName: 'Test2',
        // preferencesKeyPrefix: 'Test'
      );
}
