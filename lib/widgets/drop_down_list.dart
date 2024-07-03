import 'package:flutter/material.dart';
import 'package:news_app_ui_setup/widgets/news_list_view_builder.dart';

class DropDownList extends StatefulWidget {
  const DropDownList({super.key});

  @override
  State<DropDownList> createState() => _DropDownListState();
}

const List<String> langList = <String>['ar', 'en'];

class _DropDownListState extends State<DropDownList> {
  String dropdownValue = langList.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      // to remove the under line
      underline: const SizedBox(),
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          // line 36 -------v
          // NewsListViewBuilder().changeLanguage(dropdownValue);
          // NewsServices().getNextNews();
        });
        Taxi().changeLanguage(dropdownValue);
      },
      items: langList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(color: Colors.amber[700]),
          ),
        );
      }).toList(),
    );
  }
}
