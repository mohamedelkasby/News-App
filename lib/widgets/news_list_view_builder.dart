import 'package:flutter/material.dart';
import 'package:news_app_ui_setup/models/articles_model.dart';
import 'package:news_app_ui_setup/services/news_services.dart';
import 'package:news_app_ui_setup/widgets/news_list_view.dart';

class NewsListViewBuilder extends StatefulWidget {
  final String? categoryType;
  const NewsListViewBuilder({
    super.key,
    this.categoryType,
  });

  @override
  State<NewsListViewBuilder> createState() => _NewsListViewBuilderState();
  State<NewsListViewBuilder> creatState() => Taxi();
}

class _NewsListViewBuilderState extends State<NewsListViewBuilder> {
  var article;
  final controller = ScrollController();
  List<ArticlesModel> articleData = [];
  NewsServices news = NewsServices();
  @override
  void initState() {
    article = news.getGeneralNews(widget.categoryType);
    controller.addListener(() {
      if (controller.offset == controller.position.maxScrollExtent) {
        setState(() {
          article = news.getNextNews();
        });
      }
    });
    super.initState();
  }

/////////// errrrrrrrrrrrrrrrrrrrrrrror ///////////
  Future<void> changeLanguage(language) async {
    articleData.clear();
    Future.delayed(const Duration(seconds: 2));
    news.getNewsLanguage(language);
    List<ArticlesModel> data = [];
    data = await news.getGeneralNews(widget.categoryType);
  }
///////////////////////////////////////////////////

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
                              : articleData.isEmpty
                                  ? const Text(
                                      "There Is No More\nData...",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 35,
                                        backgroundColor:
                                            Color.fromARGB(255, 239, 237, 237),
                                      ),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.amber,
                                      ),
                                    );
                        },
                      ),
                    ),
                  ],
                )
                //     ListView.builder(
                //   shrinkWrap: true,
                //   controller: controller,
                //   physics: const BouncingScrollPhysics(),
                //   itemCount: articleData.length + 1,
                //   itemBuilder: (context, index) {
                //     return index < articleData.length
                //         ? NewsListView(
                //             article: articleData[index],
                //           )
                //         : const Center(
                //             child: CircularProgressIndicator(
                //             color: Colors.amber,
                //           ));
                //   },
                // ),
                ),
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

class Taxi extends _NewsListViewBuilderState {}
