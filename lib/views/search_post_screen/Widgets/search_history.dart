import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/views/search_post_screen/Screens/search_post_result.dart';

import '../Controllers/search_history_controller.dart';
import '../Controllers/search_post_controller.dart';

class SearchHistory extends ConsumerWidget {
  final String searchHeroTag;
  const SearchHistory({super.key, required this.searchHeroTag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchPostsProvider);
    final searchHistoryList = ref.watch(searchHistoryProvider);
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 0.4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: searchHistoryList.length,
        itemBuilder: (context, index) {
          return SizedBox(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: const BoxDecoration(
                // color: Colors.red,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              child: InkWell(
                onTap: () async {
                  // ref.watch(filterControllerProvider.notifier).initWithSearchQuery(searchHistoryList[index]);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => SearchPostResult(searchHeroTag: searchHeroTag, searchQuery: searchHistoryList[index]),
                  ));
                },
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          searchHistoryList[index],
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        ref.read(searchPostsProvider.notifier).deleteSingleItemInSearchHistroy(searchHistoryList[index]);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
