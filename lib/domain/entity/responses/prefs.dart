
import 'dart:convert';

import 'login_response.dart';

PreferencesResponse preferencesResponseFromJson(String str) => PreferencesResponse.fromJson(json.decode(str));

String preferencesResponseToJson(PreferencesResponse data) => json.encode(data.toJson());

class PreferencesResponse {
  final String? message;
  final String? token;
  final PreferencesData? data;

  PreferencesResponse({
     this.message,
     this.token,
    required this.data,
  });

  factory PreferencesResponse.fromJson(Map<String, dynamic> json) => PreferencesResponse(
    message: json["message"],
    token: json["token"],
    data: json['data'] != null ? PreferencesData.fromJson(json['data']) : null,
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "token":token,
    "data": data!.toJson(),
  };
}

class PreferencesData {
  final User user;
  //final Preferences? preferences;

  PreferencesData({
    required this.user,
   // required this.preferences,
  });

  factory PreferencesData.fromJson(Map<String, dynamic> json) => PreferencesData(
    user: User.fromJson(json["user"]),
   // preferences: Preferences.fromJson(json["preferences"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
   // "preferences": preferences!.toJson(),
  };
}


class User {
  final int id;
  final String name;
  final String email;
  final Preferences? preferences;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    preferences: Preferences.fromJson(json["preferences"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "preferences": preferences!.toJson(),
  };
}
