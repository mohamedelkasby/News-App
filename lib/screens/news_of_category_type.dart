import 'package:flutter/material.dart';
import 'package:news_app_ui_setup/widgets/news_list_view_builder.dart';

class NewsOfCategoryType extends StatefulWidget {
  final String categorytype;
  const NewsOfCategoryType(this.categorytype, {super.key});

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
            // const Padding(
            //   padding: EdgeInsets.only(left: 20),
            //   child: DropDownList(),
            // ),
          ],
        ),
      ),
      body: NewsListViewBuilder(categoryType: widget.categorytype),
    );
  }
}
