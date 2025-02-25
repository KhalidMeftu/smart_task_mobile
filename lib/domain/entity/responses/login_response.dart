import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  final String token;
  final User user;

  LoginResponse({
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    token: json["token"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user.toJson(),
  };
}

class User {
  final int id;
  final String name;
  final String email;
  final Preferences preferences;

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
    "preferences": preferences.toJson(),
  };
}

class Preferences {
  final int id;
  final int userId;
  final int twoFactorAuth;
  final String themeMode;
  final int notifications;
  final DateTime createdAt;
  final DateTime updatedAt;

  Preferences({
    required this.id,
    required this.userId,
    required this.twoFactorAuth,
    required this.themeMode,
    required this.notifications,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) => Preferences(
    id: json["id"],
    userId: json["user_id"],
    twoFactorAuth: json["two_factor_auth"],
    themeMode: json["theme_mode"],
    notifications: json["notifications"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "two_factor_auth": twoFactorAuth,
    "theme_mode": themeMode,
    "notifications": notifications,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
