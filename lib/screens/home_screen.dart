import 'package:flutter/material.dart';
import 'package:news_app_ui_setup/services/news_services.dart';
import 'package:news_app_ui_setup/widgets/category_list_view_builder.dart';
import 'package:news_app_ui_setup/widgets/drop_down_list.dart';
import 'package:news_app_ui_setup/widgets/news_list_view_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentLanguage = 'ar';
  String? searchQuery;
  final TextEditingController _searchController = TextEditingController();
  final NewsServices _newsService = NewsServices();

  void _updateLanguage(String newLang) {
    setState(() {
      currentLanguage = newLang;
      searchQuery = null;
    });
    _newsService.getNewsLanguage(newLang);
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    Navigator.pop(context);
    _searchController.clear();
    setState(() {
      searchQuery = query;
    });
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(Icons.search, color: Colors.amber[700]),
            const SizedBox(width: 10),
            const Text(
              "Search News",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: TextField(
          controller: _searchController,
          autofocus: true,
          onSubmitted: (_) => _performSearch(),
          decoration: InputDecoration(
            hintText: "Enter search terms",
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(Icons.search, color: Colors.amber[700]),
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: _performSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Search"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  "News",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Text(
                  "Cloud",
                  style: TextStyle(
                    color: Colors.amber[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                DropDownList(
                  currentLanguage: currentLanguage,
                  onLanguageChanged: _updateLanguage,
                ),
                IconButton(
                  onPressed: () {
                    _showSearchDialog(context);
                    _searchController.clear();
                  },
                  icon: const Icon(
                    Icons.search_rounded,
                    size: 28,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            titleSpacing: 10,
            floating: true,
            toolbarHeight: 130,
            title: CategoryListViewBuilder(
              language: currentLanguage,
            ),
          ),
          if (searchQuery != null)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.amber[700], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Search results for: "$searchQuery"',
                        style: TextStyle(
                          color: Colors.amber[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.close,
                            color: Colors.amber[700], size: 20),
                        onPressed: () => setState(() => searchQuery = null),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 220,
                child: NewsListViewBuilder(
                  categoryType: searchQuery ?? "top",
                  language: currentLanguage,
                  isSearch: searchQuery != null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
