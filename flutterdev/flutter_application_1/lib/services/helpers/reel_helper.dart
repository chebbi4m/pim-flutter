
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/response/reel_res.dart';
import 'package:reels_viewer/src/models/reel_model.dart';
import 'package:flutter_application_1/services/config.dart';

class ReelHelper {
  static var client = http.Client();

  static Future<List<ReelModel>> getReels() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };

    var url = Uri.http(Config.apiUrl, Config.reelUrl);
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      var responseBody = response.body;
      if (responseBody.isNotEmpty) {
        var postsList = getAllUsersReelsResFromJson(responseBody);
        var reelsList = mapReelResListToReelModelList(postsList);
        return reelsList ?? []; // Return an empty list if reelsList is null
      } else {
        throw Exception("Empty response body");
      }
    } else {
      throw Exception(
          "Failed to get Reels. Status code: ${response.statusCode}");
    }
  }
}
