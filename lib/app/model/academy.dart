// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

Academy academyFromJson(String str) => Academy.fromJson(json.decode(str));

String academytToJson(Academy data) => json.encode(data.toJson());

class Academy {
  Academy({
    this.postId,
    this.username,
    this.description,
    this.publishedAt,
    this.uuid,
    this.postUrl,
    this.profImg,
    this.isVerify,
    this.like,
    this.upPost,
    this.imgPath,
  });

  String? postId;
  String? username;
  String? description;
  DateTime? publishedAt;
  String? uuid;
  String? postUrl;
  String? profImg;
  bool? isVerify;
  final like;
  final upPost;
  String? imgPath;

  factory Academy.fromJson(Map<String, dynamic> json) => Academy(
        postId: json["postId"] == null ? null : json["postId"],
        username: json["username"] == null ? null : json["username"],
        description: json["description"] == null ? null : json["description"],
        publishedAt: json["published_at"] == null
            ? null
            : DateTime.parse(json["published_at"]),
        uuid: json["uuid"] == null ? null : json["uuid"],
        postUrl: json["postUrl"] == null ? null : json["postUrl"],
        profImg: json["profImg"] == null ? null : json["profImg"],
        isVerify: json["isVerify"] == null ? null : json["isVerify"],
        like: json["like"] == null ? null : json["like"],
        upPost: json["upPost"] == null ? null : json["upPost"],
        imgPath: json["imgPath"] == null ? null : json["imgPath"],
      );

  Map<String, dynamic> toJson() => {
        "postId": postId == null ? null : postId,
        "username": username == null ? null : username,
        "description": description == null ? null : description,
        "published_at":
            publishedAt == null ? null : publishedAt?.toIso8601String(),
        "uuid": uuid == null ? null : uuid,
        "postUrl": postUrl == null ? null : postUrl,
        "profImg": profImg == null ? null : profImg,
        "isVerify": isVerify == null ? null : isVerify,
        "like": like == null ? null : like,
        "upPost": upPost == null ? null : upPost,
        "imgPath": imgPath == null ? null : imgPath,
      };
}
