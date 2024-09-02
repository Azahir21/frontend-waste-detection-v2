import 'dart:convert';

class PostSampah {
  String? detail;
  String? badge;
  bool? updatedBadge;

  PostSampah({
    this.detail,
    this.badge,
    this.updatedBadge,
  });

  factory PostSampah.fromRawJson(String str) =>
      PostSampah.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostSampah.fromJson(Map<String, dynamic> json) => PostSampah(
        detail: json["detail"],
        badge: json["badge"],
        updatedBadge: json["updated_badge"],
      );

  Map<String, dynamic> toJson() => {
        "detail": detail,
        "badge": badge,
        "updated_badge": updatedBadge,
      };
}
