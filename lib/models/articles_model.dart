class ArticlesModel {
  final String title;
  final String? subTitle;
  final String? imageSource;
  final String link;
  ArticlesModel(
      {required this.title,
      required this.imageSource,
      required this.link,
      required this.subTitle});
  factory ArticlesModel.fromJson(json) {
    return ArticlesModel(
      title: json["title"],
      imageSource: json["image_url"],
      link: json["link"],
      subTitle: json["description"],
    );
  }
}
