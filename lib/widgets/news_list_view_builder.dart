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
  final ScrollController scrollController = ScrollController();
  late NewsServices news;
  late Future<List<ArticlesModel>> article;
  List<ArticlesModel> articleData = [];
  bool isLoadingMore = false;
  bool hasReachedEnd = false;

  @override
  void initState() {
    super.initState();
    news = NewsServices();
    _setupNewsService();
    article = news.getGeneralNews(widget.categoryType);
    scrollController.addListener(_handleScroll);
  }

  void _handleScroll() async {
    if (scrollController.offset == scrollController.position.maxScrollExtent &&
        !isLoadingMore &&
        !hasReachedEnd) {
      setState(() {
        isLoadingMore = true;
      });

      final List<ArticlesModel> newArticles = await news.getNextNews();

      if (mounted) {
        setState(() {
          if (newArticles.isEmpty) {
            hasReachedEnd = true;
          } else {
            article = Future.value([...articleData, ...newArticles]);
          }
          isLoadingMore = false;
        });
      }
    }
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
    hasReachedEnd = false;
  }

  void _resetAndFetchNews() {
    articleData.clear();
    hasReachedEnd = false;
    news.getNewsLanguage(widget.language);
    article = news.getGeneralNews(widget.categoryType).then((data) {
      articleData = data;
      return data;
    });
    setState(() {});
  }

  Widget _buildEndWidget() {
    if (hasReachedEnd) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.grey,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up!',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    } else if (isLoadingMore) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(
            color: Colors.amber,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      color: Colors.amber[700],
      onRefresh: () async {
        return _resetAndFetchNews();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.newspaper,
                    size: 50,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No news available',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pull to refresh',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArticlesModel>>(
      future: article,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          articleData = snapshot.data!;

          if (articleData.isEmpty) {
            return _buildEmptyState();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: RefreshIndicator(
              color: Colors.amber[700],
              onRefresh: () async {
                articleData.clear();
                hasReachedEnd = false;
                await Future.delayed(const Duration(seconds: 3));
                List<ArticlesModel> reloadedData =
                    await news.getGeneralNews(widget.categoryType);
                if (mounted) {
                  setState(() {
                    articleData = reloadedData;
                  });
                }
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: articleData.length + 1,
                      (context, index) {
                        if (index < articleData.length) {
                          return NewsListView(
                            article: articleData[index],
                          );
                        } else {
                          return _buildEndWidget();
                        }
                      },
                    ),
                  ),
                  // SliverToBoxAdapter(
                  //   child: _buildEndWidget(),
                  // )
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return _buildEmptyState();
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
