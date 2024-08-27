import 'dart:convert';

class Article {
  String? title;
  String? content;
  String? image;
  DateTime? createdAt;

  Article({
    this.title,
    this.content,
    this.image,
    this.createdAt,
  });

  factory Article.fromRawJson(String str) => Article.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        title: json["title"],
        content: json["content"],
        image: json["image"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "image": image,
        "createdAt": createdAt?.toIso8601String(),
      };
}

List<Article> parseArticles(String str) {
  final parsed = json.decode(str).cast<Map<String, dynamic>>();
  return parsed.map<Article>((json) => Article.fromJson(json)).toList();
}
