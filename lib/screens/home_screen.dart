import 'package:flutter/material.dart';
import 'package:news_app_ui_setup/widgets/category_list_view_builder.dart';
import 'package:news_app_ui_setup/widgets/drop_down_list.dart';
import 'package:news_app_ui_setup/widgets/news_list_view_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentLanguage = 'ar'; // Default language

  void updateLanguage(String newLang) {
    setState(() {
      currentLanguage = newLang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "News",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Cloud",
              style: TextStyle(
                  color: Colors.amber[800], fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: //DropDownList(),
                  DropDownList(
                currentLanguage: currentLanguage,
                onLanguageChanged: updateLanguage,
              ),
            ),
            // IconButton(
            //   onPressed: () {
            //     showDialog(
            //       context: context,
            //       builder: (context) {
            //         return TextField(
            //           onSubmitted: (value) {
            //             setState(() {
            //               Navigator.of(context).pop();
            //               NewsServices().searchNews(value);
            //             });
            //           },
            //         );
            //       },
            //     );
            //   },
            //   icon: const Icon(Icons.search_rounded),
            // )
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            titleSpacing: 10,
            floating: true,
            toolbarHeight: 130,
            title: CategoryListViewBuilder(
              language: currentLanguage,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              //we need to remove the numbers.
              height: 600,
              child: NewsListViewBuilder(
                categoryType: "top",
                language: currentLanguage,
              ),
            ),
          )
        ],
      ),
    );
  }
}
