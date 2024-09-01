import 'dart:convert';

class Leaderboards {
  List<Leaderboard> leaderboards;

  Leaderboards({
    required this.leaderboards,
  });

  factory Leaderboards.fromRawJson(String str) =>
      Leaderboards.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Leaderboards.fromJson(List<dynamic> json) => Leaderboards(
        leaderboards:
            List<Leaderboard>.from(json.map((x) => Leaderboard.fromJson(x))),
      );

  List<dynamic> toJson() =>
      List<dynamic>.from(leaderboards.map((x) => x.toJson()));
}

class Leaderboard {
  int? userId;
  String? username;
  int? totalPoints;
  int? ranking;
  bool? isQueryingUser;

  Leaderboard({
    this.userId,
    this.username,
    this.totalPoints,
    this.ranking,
    this.isQueryingUser,
  });

  factory Leaderboard.fromRawJson(String str) =>
      Leaderboard.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Leaderboard.fromJson(Map<String, dynamic> json) => Leaderboard(
        userId: json["user_id"],
        username: json["username"],
        totalPoints: json["total_points"],
        ranking: json["ranking"],
        isQueryingUser: json["is_querying_user"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "username": username,
        "total_points": totalPoints,
        "ranking": ranking,
        "is_querying_user": isQueryingUser,
      };
}
