import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/helpers/reel_helper.dart';
import 'package:reels_viewer/reels_viewer.dart';

class ReelsNotifier extends ChangeNotifier {
  late Future<List<ReelModel>> reelsList;

  getReels() {
    reelsList = ReelHelper.getReels();
  }
}
