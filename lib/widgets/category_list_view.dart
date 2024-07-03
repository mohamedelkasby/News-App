import 'package:flutter/material.dart';
import 'package:news_app_ui_setup/models/category_model.dart';
import 'package:news_app_ui_setup/screens/news_of_category_type.dart';
import 'package:stroke_text/stroke_text.dart';

class CategoryListView extends StatelessWidget {
  final Category? category;
  final Color color;
  const CategoryListView(
      {super.key, required this.category, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsOfCategoryType(category!.categoryName),
            ));
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  category!.categoryImage,
                  height: 110,
                  width: 170,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  //the position of text in the image of the category
                  bottom: 23,
                  child: StrokeText(
                    text: category!.categoryName[0].toUpperCase() +
                        category!.categoryName.substring(1),
                    strokeColor: Colors.amber,
                    strokeWidth: 1.8,
                    textColor: color,
                    textStyle: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
