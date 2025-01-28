import 'dart:convert';

class ArticleList {
  List<Article>? data;
  int? totalCount;
  int? page;
  int? pageSize;
  int? totalPage;

  ArticleList({
    this.data,
    this.totalCount,
    this.page,
    this.pageSize,
    this.totalPage,
  });

  factory ArticleList.fromRawJson(String str) =>
      ArticleList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ArticleList.fromJson(Map<String, dynamic> json) => ArticleList(
        data: json["data"] == null
            ? []
            : List<Article>.from(json["data"]!.map((x) => Article.fromJson(x))),
        totalCount: json["total_count"],
        page: json["page"],
        pageSize: json["page_size"],
        totalPage: json["total_page"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total_count": totalCount,
        "page": page,
        "page_size": pageSize,
        "total_page": totalPage,
      };
}

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
