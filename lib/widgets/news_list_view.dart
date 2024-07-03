import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app_ui_setup/models/articles_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsListView extends StatefulWidget {
  final ArticlesModel article;

  const NewsListView({super.key, required this.article});

  @override
  State<NewsListView> createState() => _NewsListViewState();
}

class _NewsListViewState extends State<NewsListView> {
  Future urlLuncher() async {
    final Uri url = Uri.parse(widget.article.link);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            try {
              urlLuncher();
            } catch (e) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("$e"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ));
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: widget.article.imageSource != null
                ? CachedNetworkImage(
                    height: 210,
                    fit: BoxFit.cover,
                    imageUrl: widget.article.imageSource!,
                    placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                      color: Colors.amber,
                    )),
                    // errorListener: (value) => Icon(Icons.error),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/no-image.jpg",
                      height: 210,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    "assets/no-image.jpg",
                    height: 210,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            children: [
              Text(
                widget.article.title,
                maxLines: 2,
                //if the text arabic
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                widget.article.subTitle ?? " ",
                maxLines: 2,
                //if the text arabic
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.amber,
        )
      ],
    );
  }
}
