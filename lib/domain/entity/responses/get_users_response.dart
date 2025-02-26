
import 'dart:convert';
List<GetUsersResponse> getUsersResponseFromJson(String str) => List<GetUsersResponse>.from(json.decode(str).map((x) => GetUsersResponse.fromJson(x)));
String getUsersResponseToJson(List<GetUsersResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetUsersResponse {
  final int id;
  final String name;
  final String email;

  GetUsersResponse({
    required this.id,
    required this.name,
    required this.email,
  });

  factory GetUsersResponse.fromJson(Map<String, dynamic> json) => GetUsersResponse(
    id: json["id"],
    name: json["name"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
  };
}
