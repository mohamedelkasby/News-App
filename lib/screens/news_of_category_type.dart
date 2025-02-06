import 'package:flutter/material.dart';
import 'package:news_app_ui_setup/widgets/news_list_view_builder.dart';

class NewsOfCategoryType extends StatefulWidget {
  final String categorytype;
  final String language;

  const NewsOfCategoryType({
    super.key,
    required this.categorytype,
    required this.language,
  });
  @override
  State<NewsOfCategoryType> createState() => _NewsOfCategoryTypeState();
}

class _NewsOfCategoryTypeState extends State<NewsOfCategoryType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 50,
            ),
            const Text(
              "News",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Cloud",
              style: TextStyle(
                  color: Colors.amber[800], fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: NewsListViewBuilder(
        categoryType: widget.categorytype,
        language: widget.language,
      ),
    );
  }
}
