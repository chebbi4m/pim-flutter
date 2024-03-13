import 'dart:convert';

import 'package:reels_viewer/reels_viewer.dart';

List<ReelRes> getAllUsersReelsResFromJson(String str) =>
    List<ReelRes>.from(json.decode(str).map((x) => ReelRes.fromJson(x)));

String getAllUsersReelsResToJson(List<ReelRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReelRes {
  final String id;
  final String url;
  final List<LikeCount> likeCount;
  final String userName;
  final String profileUrl;
  final String reelDescription;
  final String musicName;
  final List<CommentList> commentList;
  final int v;

  ReelRes({
    required this.id,
    required this.url,
    required this.likeCount,
    required this.userName,
    required this.profileUrl,
    required this.reelDescription,
    required this.musicName,
    required this.commentList,
    required this.v,
  });

  factory ReelRes.fromJson(Map<String, dynamic> json) => ReelRes(
        id: json["_id"],
        url: json["url"],
        likeCount: List<LikeCount>.from(
            json["likeCount"].map((x) => LikeCount.fromJson(x))),
        userName: json["userName"],
        profileUrl: json["profileUrl"],
        reelDescription: json["reelDescription"],
        musicName: json["musicName"],
        commentList: List<CommentList>.from(
            json["commentList"].map((x) => CommentList.fromJson(x))),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "url": url,
        "likeCount": List<dynamic>.from(likeCount.map((x) => x.toJson())),
        "userName": userName,
        "profileUrl": profileUrl,
        "reelDescription": reelDescription,
        "musicName": musicName,
        "commentList": List<dynamic>.from(commentList.map((x) => x.toJson())),
        "__v": v,
      };
}

class CommentList {
  final String comment;
  final String userProfilePic;
  final String userName;
  final DateTime commentTime;
  final String id;

  CommentList({
    required this.comment,
    required this.userProfilePic,
    required this.userName,
    required this.commentTime,
    required this.id,
  });

  factory CommentList.fromJson(Map<String, dynamic> json) => CommentList(
        comment: json["comment"],
        userProfilePic: json["userProfilePic"],
        userName: json["userName"],
        commentTime: DateTime.parse(json["commentTime"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "userProfilePic": userProfilePic,
        "userName": userName,
        "commentTime": commentTime.toIso8601String(),
        "_id": id,
      };
}

class LikeCount {
  final String userId;
  final String reelId;
  final String id;

  LikeCount({
    required this.userId,
    required this.reelId,
    required this.id,
  });

  factory LikeCount.fromJson(Map<String, dynamic> json) => LikeCount(
        userId: json["userId"],
        reelId: json["reelId"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "reelId": reelId,
        "_id": id,
      };
}

List<ReelModel> mapReelResListToReelModelList(List<ReelRes> reelResList) {
  return reelResList.map((reelRes) {
    return ReelModel(
      reelRes.url,
      reelRes.userName,
      id: reelRes.id,
      isLiked: reelRes.likeCount.any((like) => like.userId == "yourUserId"),
      likeCount: reelRes.likeCount.length,
      profileUrl: reelRes.profileUrl,
      reelDescription: reelRes.reelDescription,
      musicName: reelRes.musicName,
      commentList: reelRes.commentList
          .map((comment) => ReelCommentModel(
                id: comment.id,
                comment: comment.comment,
                userProfilePic: comment.userProfilePic,
                userName: comment.userName,
                commentTime: comment.commentTime,
              ))
          .toList(),
    );
  }).toList();
}
