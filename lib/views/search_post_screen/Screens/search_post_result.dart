import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/utils/log_util.dart';
import 'package:plo/common/widgets/custom_app_bar.dart';
import 'package:plo/common/widgets/post_list_widget.dart';
import 'package:plo/views/search_post_screen/Widgets/search_filter/filter_button.dart';

import '../../../model/post_model.dart';
import '../../../model/state_model/search_filter_options_model.dart';
import '../../../services/search_service.dart';
import '../Controllers/filter_options_controller.dart';
import '../Widgets/search_bar.dart';

final searchPostFutureProvider = FutureProvider.family.autoDispose<List<PostModel>?, FilterOptions>((ref, filterOptions) async {
  final posts = await ref.watch(searchServiceProvider).searchPost(filterOptions);
  return posts;
});

class SearchPostResult extends ConsumerStatefulWidget {
  final String? searchHeroTag;
  final String searchQuery;
  const SearchPostResult({super.key, this.searchHeroTag, required this.searchQuery});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPostResultState();
}

class _SearchPostResultState extends ConsumerState<SearchPostResult> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(filterOptionsProvider.notifier).setSearchQuery(widget.searchQuery);
      // ref.watch(filterOptionsProvider.notifier).setFilterOptions()
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterOptions = ref.watch(filterOptionsProvider);
    return Scaffold(
      appBar: const HomeButtonAppBar(title: "홈으로"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            children: [
              Row(
                children: [
                  CustomSearchBar(searchQuery: widget.searchQuery),
                  SearchFilterButton(filterOptions: filterOptions),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ProductResultWidget(filterOptions: filterOptions),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductResultWidget extends ConsumerWidget {
  final FilterOptions filterOptions;
  const ProductResultWidget({super.key, required this.filterOptions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logToConsole("Product result widget build was called");
    return Container(
      child: ref.watch(searchPostFutureProvider(filterOptions)).when(
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
            error: (error, stackTrace) => Text("Error: $error"),
            data: (data) {
              if (data == null) {
                return ErrorWidget.withDetails(
                  message: "Error occured",
                );
              }
              return PostListWidget(
                posts: data,
                refreshFunction: () {
                  ref.refresh(searchPostFutureProvider(filterOptions));
                },
              );
            },
          ),
    );
  }
}
