import 'package:flutter/material.dart';
import 'package:news_app_ui_setup/models/articles_model.dart';
import 'package:news_app_ui_setup/services/news_services.dart';
import 'package:news_app_ui_setup/widgets/news_list_view.dart';

class NewsListViewBuilder extends StatefulWidget {
  final String? categoryType;
  final String language;

  const NewsListViewBuilder({
    super.key,
    this.categoryType,
    required this.language,
  });

  @override
  State<NewsListViewBuilder> createState() => _NewsListViewBuilderState();
}

class _NewsListViewBuilderState extends State<NewsListViewBuilder> {
  // var article;
  final ScrollController controller = ScrollController();
  late NewsServices news;
  late Future<List<ArticlesModel>> article;
  List<ArticlesModel> articleData = [];
  // NewsServices news = NewsServices();
  @override
  void initState() {
    super.initState();
    news = NewsServices();
    _setupNewsService();
    controller.addListener(_scrollListener);
  }

  @override
  void didUpdateWidget(NewsListViewBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.language != widget.language ||
        oldWidget.categoryType != widget.categoryType) {
      _resetAndFetchNews();
    }
  }

  void _setupNewsService() {
    news.getNewsLanguage(widget.language);
    article = news.getGeneralNews(widget.categoryType);
  }

  void _resetAndFetchNews() {
    articleData.clear();
    news.getNewsLanguage(widget.language);
    article = news.getGeneralNews(widget.categoryType).then((data) {
      articleData = data;
      return data;
    });
    setState(() {});
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      setState(() {
        article = news.getNextNews().then((newData) {
          articleData.addAll(newData);
          return articleData;
        });
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ////////
    return FutureBuilder<List<ArticlesModel>>(
      future: article,
      builder: (context, snapshot) {
        // List<ArticlesModel> articleData = snapshot.data!;
        if (snapshot.hasData) {
          articleData = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
            ),
            child: RefreshIndicator(
                color: Colors.amber[700],
                onRefresh: () async {
                  articleData.clear();
                  Future.delayed(const Duration(seconds: 3));
                  List<ArticlesModel> relodedData =
                      await news.getGeneralNews(widget.categoryType);
                  articleData = relodedData;
                  setState(() {});
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: controller,
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: articleData.length + 1,
                        (context, index) {
                          return index < articleData.length
                              ? NewsListView(
                                  article: articleData[index],
                                )
                              // : articleData.isEmpty
                              //     ? const Text(
                              //         "There Is No More\nData...",
                              //         textAlign: TextAlign.center,
                              //         style: TextStyle(
                              //           fontSize: 35,
                              //           backgroundColor:
                              //               Color.fromARGB(255, 239, 237, 237),
                              //         ),
                              //       )
                              : const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.amber,
                                  ),
                                );
                        },
                      ),
                    ),
                  ],
                )),
          );
        } else if (snapshot.hasError) {
          return const AlertDialog(
            title: Text(
              "there is no data.\ntry tomorrow ^_^",
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          );
        }
      },
    );
  }
}
