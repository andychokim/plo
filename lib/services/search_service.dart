import 'package:algoliasearch/algoliasearch.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/repository/firebase_post_repository.dart';

import '../common/utils/log_util.dart';
import '../constants/algolia_constants.dart';
import '../model/post_model.dart';
import '../model/state_model/search_filter_options_model.dart';

class SearchService {
  SearchService({required this.ref});
  final Ref ref;

  Stream getSearchQuery(String? query) {
    if (query == null || query.isEmpty) {
      return const Stream.empty();
    }
    final searchClient = SearchClient(
      apiKey: AlgoliaConstants.algoliaApiKey,
      appId: AlgoliaConstants.algoliaAppId,
    );
    return searchClient
        .searchIndex(request: SearchForHits(indexName: AlgoliaConstants.sortByNewestIndexName, query: query, page: 0, hitsPerPage: 10))
        .asStream();
  }

  Future<List<PostModel>?> searchPost(FilterOptions filterOptions) async {
    logToConsole("arrived here: searchPost in search_service");
    try {
      if (filterOptions.searchQuery.isEmpty || filterOptions.searchQuery == " ") {
        logToConsole("filterOptions is empty");
        return null;
      }
      final searchClient = SearchClient(
        apiKey: AlgoliaConstants.algoliaApiKey,
        appId: AlgoliaConstants.algoliaAppId,
      );

      logToConsole(
          "SearchService: Searching posts with filter options: ${filterOptions.sortOptions}, ${filterOptions.categorySelected}, ${filterOptions.searchQuery}");
      // logToConsole("filterOptions.sortOptions.sortByAlgoliaIndexName(): ${filterOptions.sortOptions.sortByAlgoliaIndexName()}");
      final queryHits = SearchForHits(
        indexName: filterOptions.sortOptions.sortByAlgoliaIndexName(),
        query: filterOptions.searchQuery,
        facetFilters: [filterOptions.getCategoryList()],
      );
      logToConsole("queryHits: ${queryHits}");
      final responseHits = await searchClient.searchIndex(request: queryHits);

      logToConsole("SearchService: Algolia response received with ${responseHits.hits.length} hits");

      if (responseHits.hits.isEmpty) {
        return [];
      }
      List<String> pidList = [];
      for (var hit in responseHits.hits) {
        pidList.add(hit[PostModelFieldNameConstants.pid]);
      }

      logToConsole("SearchService: Fetching posts from Firebase with pids: $pidList");

      final List<PostModel>? posts = await ref.watch(firebasePostRepositoryProvider).fetchMultiplePostsFromHitList(pidList);

      logToConsole("SearchService: Fetched ${posts?.length ?? 0} posts from Firebase");

      return posts;
    } catch (err) {
      logToConsole("Error in searchItem: $err");
      return null;
    }
  }
}

final searchServiceProvider = Provider.autoDispose<SearchService>((ref) {
  return SearchService(ref: ref);
});
