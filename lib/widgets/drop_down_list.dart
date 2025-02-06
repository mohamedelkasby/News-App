import 'package:flutter/material.dart';

class DropDownList extends StatefulWidget {
  const DropDownList({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  final String currentLanguage;
  final Function(String) onLanguageChanged;
  @override
  State<DropDownList> createState() => _DropDownListState();
}

const List<String> langList = <String>['ar', 'en'];

class _DropDownListState extends State<DropDownList> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.currentLanguage;
  }

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
        });
        widget.onLanguageChanged(value!);
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
