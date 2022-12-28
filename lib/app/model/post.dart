// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  Post({
    this.postId,
    this.username,
    this.description,
    this.publishedAt,
    this.uuid,
    this.postUrl,
    this.profImg,
    this.like,
  });

  String? postId;
  String? username;
  String? description;
  DateTime? publishedAt;
  String? uuid;
  String? postUrl;
  String? profImg;
  final like;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        postId: json["postId"] == null ? null : json["postId"],
        username: json["username"] == null ? null : json["username"],
        description: json["description"] == null ? null : json["description"],
        publishedAt: json["published_at"] == null
            ? null
            : DateTime.parse(json["published_at"]),
        uuid: json["uuid"] == null ? null : json["uuid"],
        postUrl: json["postUrl"] == null ? null : json["postUrl"],
        profImg: json["profImg"] == null ? null : json["profImg"],
        like: json["like"] == null ? null : json["like"],
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
        "like": like == null ? null : like,
      };
}
