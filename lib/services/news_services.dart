import 'package:dio/dio.dart';
import 'package:news_app_ui_setup/const.dart';
import 'package:news_app_ui_setup/models/articles_model.dart';

class NewsServicesException implements Exception {
  final String message;
  final int? statusCode;

  NewsServicesException(this.message, [this.statusCode]);

  @override
  String toString() {
    return 'NewsServicesException: $message ${statusCode != null ? '(Status Code: $statusCode)' : ''}';
  }
}

class NewsServices {
  final Dio _dio = Dio();
  String _nextPage = "";
  String _lang = "ar";
  String _categoryType = "";
  List<ArticlesModel> _newsData = [];

  void getNewsLanguage(String language) {
    _lang = language;
    _newsData.clear();
    _nextPage = "";
    // getNextNews();
  }

  Future<List<ArticlesModel>> getGeneralNews(String? categoryName) async {
    // Reset data for new request
    _newsData.clear();
    _nextPage = "";

    // Determine category type
    _categoryType =
        (categoryName == null || categoryName.isEmpty) ? "top" : categoryName;

    try {
      // Construct URL
      final url =
          "$baseUrl?apikey=$apikey&category=$_categoryType&language=$_lang";

      // Make the API call
      final response = await _dio.get(url);

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse articles
        final List<dynamic> articles = response.data["results"] ?? [];

        // Map articles to models
        _newsData =
            articles.map((article) => ArticlesModel.fromJson(article)).toList();

        // Safely extract next page token
        _nextPage = response.data["nextPage"]?.toString() ?? "";

        return _newsData;
      } else {
        print('Failed to load news. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error in getGeneralNews: $e');
      return [];
    }
  }

  Future<List<ArticlesModel>> getNextNews() async {
    // If no next page, return current data or fetch initial data
    if (_nextPage.isEmpty) {
      return await getGeneralNews(_categoryType);
    }

    try {
      // Construct URL for next page
      final url =
          "$baseUrl?apikey=$apikey&category=$_categoryType&language=$_lang&page=$_nextPage";

      // Make the API call
      final response = await _dio.get(url);

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse articles
        final List<dynamic> articles = response.data["results"] ?? [];

        // Map new articles
        final newArticles =
            articles.map((article) => ArticlesModel.fromJson(article)).toList();

        // Add new articles to existing data
        _newsData.addAll(newArticles);

        // Safely extract next page token
        _nextPage = response.data["nextPage"]?.toString() ?? "";

        return _newsData;
      } else {
        print('Failed to load next news. Status code: ${response.statusCode}');
        return _newsData;
      }
    } catch (e) {
      print('Error in getNextNews: $e');
      return _newsData;
    }
  }

  Future<List<ArticlesModel>> searchNews({required String searchValue}) async {
    // Clear previous search results
    _newsData.clear();
    _nextPage = "";

    try {
      // Ensure the search value is not empty
      if (searchValue.trim().isEmpty) {
        return [];
      }

      // Construct search URL
      final url =
          "$baseUrl?apikey=$apikey&q=${Uri.encodeQueryComponent(searchValue)}";

      // Make the API call
      final response = await _dio.get(url);

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse articles
        final List<dynamic> articles = response.data["results"] ?? [];

        // Map articles
        _newsData =
            articles.map((article) => ArticlesModel.fromJson(article)).toList();

        // Safely extract next page token
        _nextPage = response.data["nextPage"]?.toString() ?? "";

        return _newsData;
      } else {
        print('Failed to search news. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error in searchNews: $e');
      return [];
    }
  }
}
