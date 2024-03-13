import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/reelProvider.dart';
import 'package:reels_viewer/reels_viewer.dart';

class reelsPage extends StatefulWidget {
  @override
  _ReelsPageState createState() => _ReelsPageState();
}

class _ReelsPageState extends State<reelsPage> {
  late Future<List<ReelModel>> reelsListFuture;

  @override
  void initState() {
    super.initState();
    _fetchReels();
  }

  Future<void> _fetchReels() async {
    final reelsNotifier = ReelsNotifier();
    reelsNotifier.getReels();
    reelsListFuture = reelsNotifier.reelsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ReelModel>>(
        future: reelsListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: Text('Error fetching reels'),
            );
          } else {
            return ReelsViewer(
              reelsList: snapshot.data!,
              appbarTitle: ' Reels',
              onShare: (url) {
                log('Shared reel url ==> $url');
              },
              onLike: (url) {
                log('Liked reel url ==> $url');
              },
              onFollow: () {
                log('======> Clicked on follow <======');
              },
              onComment: (comment) {
                log('Comment on reel ==> $comment');
              },
              onClickMoreBtn: () {
                log('======> Clicked on more option <======');
              },
              onClickBackArrow: () {
                log('======> Clicked on back arrow <======');
              },
              onIndexChanged: (index) {
                log('======> Current Index ======> $index <========');
              },
              showProgressIndicator: true,
              showVerifiedTick: false,
              showAppbar: true,
            );
          }
        },
      ),
    );
  }
}
