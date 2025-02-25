import 'dart:convert';

RegistrationRequest registrationRequestFromJson(String str) => RegistrationRequest.fromJson(json.decode(str));

String registrationRequestToJson(RegistrationRequest data) => json.encode(data.toJson());

class RegistrationRequest {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  RegistrationRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  factory RegistrationRequest.fromJson(Map<String, dynamic> json) => RegistrationRequest(
    name: json["name"],
    email: json["email"],
    password: json["password"],
    passwordConfirmation: json["password_confirmation"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
    "password_confirmation": passwordConfirmation,
  };
}
