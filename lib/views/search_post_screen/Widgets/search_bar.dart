import 'package:flutter/material.dart';

import '../Screens/search_post_loop.dart';

class CustomSearchBar extends StatelessWidget {
  final String searchQuery;
  const CustomSearchBar({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "search",
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SearchBar(
          hintText: searchQuery,
          leading: const Icon(Icons.search),
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SearchPostsLoop()));
          },
          constraints: const BoxConstraints(maxHeight: 360, maxWidth: 275, minHeight: 50),
        ),
      ),
    );
  }
}
