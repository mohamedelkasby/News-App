import 'package:dio/dio.dart';
import 'package:news_app_ui_setup/models/articles_model.dart';

class NewsServices {
  final dio = Dio();
  final String apikey = "pub_37622297baad7c416e91e2025d314c7e9e721";
  final String baseUrl = "https://newsdata.io/api/1/news";
  String nextPage = "";
  String lang = "ar";
  String categoryType = "";
  List<ArticlesModel> newsData = [];
  NewsServices();
  String changedData() {
    print(lang);

    return "$baseUrl?apikey=$apikey&category=$categoryType&language=$lang";
  }

  void getNewsLanguage(language) {
    lang = language;

    newsData = [];
    nextPage = "";
    getNextNews();
    // changedData();
  }

  Future<List<ArticlesModel>> getGeneralNews(categoryName) async {
    categoryName == null || categoryName == ""
        ? categoryType = "top"
        : categoryType = categoryName;
    try {
      final response = await dio.get(changedData());
      List<dynamic> articles = response.data["results"];
      for (var article in articles) {
        ArticlesModel articlesModel = ArticlesModel(
            title: article["title"],
            imageSource: article["image_url"],
            link: article["link"],
            subTitle: article["description"]);

        newsData.add(articlesModel);
      }
      nextPage = response.data["nextPage"];
      return newsData;
    } catch (e) {
      return [];
    }
  }

  Future<List<ArticlesModel>> getNextNews() async {
    /// handle for the internet connection
    print("$lang that was imp");

    if (nextPage == "") {
      newsData = await getGeneralNews(categoryType);
      return newsData;
    } else {
      try {
        final response = await dio.get(
            "$baseUrl?apikey=$apikey&category=$categoryType&language=$lang&page=$nextPage");

        List<dynamic> articles = response.data["results"];
        for (var article in articles) {
          ArticlesModel articlesModel = ArticlesModel.fromJson(article);
          newsData.add(articlesModel);
        }
        nextPage = response.data["nextPage"];
        return newsData;
      } catch (e) {
        return [];
      }
    }
  }

  ///under test......
  Future<List<ArticlesModel>> searchNews(String searchValue) async {
    if (nextPage == "") {
      try {
        Response response =
            await dio.get("$baseUrl?apikey=$apikey&q=$searchValue");
        List<dynamic> articles = response.data["results"];
        for (var article in articles) {
          ArticlesModel articlesModel = ArticlesModel.fromJson(article);
          newsData.add(articlesModel);
        }
        nextPage = response.data["nextPage"];
        return newsData;
      } on Exception catch (e) {
        return [];
      }
    } else {
      try {
        Response response = await dio
            .get("$baseUrl?apikey=$apikey&q=$searchValue&page=$nextPage");
        List<dynamic> articles = response.data["results"];
        for (var article in articles) {
          ArticlesModel articlesModel = ArticlesModel.fromJson(article);
          newsData.add(articlesModel);
        }
        nextPage = response.data["nextPage"];
        return newsData;
      } on Exception catch (e) {
        // TODO
        return [];
      }
    }
  }
}
