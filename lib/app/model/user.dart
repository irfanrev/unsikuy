// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.username,
    this.email,
    this.phone,
    this.gender,
    this.status,
    this.bio,
    this.photoUrl,
    this.createdAt,
    this.updatedAt,
    this.uuid,
  });

  String? username;
  String? email;
  String? phone;
  String? gender;
  String? status;
  String? bio;
  String? photoUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? uuid;

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
        phone: json["phone"] == null ? null : json["phone"],
        gender: json["gender"] == null ? null : json["gender"],
        status: json["status"] == null ? null : json["status"],
        bio: json["bio"] == null ? null : json["bio"],
        photoUrl: json["photoUrl"] == null ? null : json["photoUrl"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        uuid: json["uuid"] == null ? null : json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "username": username == null ? null : username,
        "email": email == null ? null : email,
        "phone": phone == null ? null : phone,
        "gender": gender == null ? null : gender,
        "status": status == null ? null : status,
        "bio": bio == null ? null : bio,
        "photoUrl": photoUrl == null ? null : photoUrl,
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "uuid": uuid == null ? null : uuid,
      };
}
