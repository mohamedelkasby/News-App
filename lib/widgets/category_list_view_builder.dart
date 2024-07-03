import 'package:flutter/material.dart';
import 'package:news_app_ui_setup/models/category_model.dart';
import 'package:news_app_ui_setup/widgets/category_list_view.dart';

class CategoryListViewBuilder extends StatelessWidget {
  const CategoryListViewBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            // here i need to remove the numbers ................
            height: 110,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: categoryTypes.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  CategoryListView(category: categoryTypes[index]),
            ),
          ),
        ],
      ),
    );
  }
}
