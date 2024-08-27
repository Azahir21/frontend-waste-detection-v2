import 'dart:convert';

class Login {
  String? accessToken;
  String? tokenType;
  String? username;

  Login({
    this.accessToken,
    this.tokenType,
    this.username,
  });

  factory Login.fromRawJson(String str) => Login.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "username": username,
      };
}
