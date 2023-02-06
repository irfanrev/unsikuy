// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

Discuss postFromJson(String str) => Discuss.fromJson(json.decode(str));

String postToJson(Discuss data) => json.encode(data.toJson());

class Discuss {
  Discuss({
    this.postId,
    this.username,
    this.title,
    this.publishedAt,
    this.uuid,
    this.profImg,
    this.isVerify,
  });

  String? postId;
  String? username;
  String? title;
  DateTime? publishedAt;
  String? uuid;
  String? profImg;
  bool? isVerify;

  factory Discuss.fromJson(Map<String, dynamic> json) => Discuss(
        postId: json["postId"] == null ? null : json["postId"],
        username: json["username"] == null ? null : json["username"],
        title: json["title"] == null ? null : json["title"],
        publishedAt: json["published_at"] == null
            ? null
            : DateTime.parse(json["published_at"]),
        uuid: json["uuid"] == null ? null : json["uuid"],
        profImg: json["profImg"] == null ? null : json["profImg"],
        isVerify: json["isVerify"] == null ? null : json["isVerify"],
      );

  Map<String, dynamic> toJson() => {
        "postId": postId == null ? null : postId,
        "username": username == null ? null : username,
        "title": title == null ? null : title,
        "published_at":
            publishedAt == null ? null : publishedAt?.toIso8601String(),
        "uuid": uuid == null ? null : uuid,
        "profImg": profImg == null ? null : profImg,
        "isVerify": isVerify == null ? null : isVerify,
      };
}
