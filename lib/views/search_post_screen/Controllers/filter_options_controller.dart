import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/model/types/sortby_type.dart';

import '../../../model/state_model/search_filter_options_model.dart';

class FilterOptionsController extends StateNotifier<FilterOptions> {
  FilterOptionsController() : super(FilterOptions());

  void setFilterOptions(FilterOptions filterOptions) {
    state = filterOptions;
  }

  void setSearchQuery(String searchQuery) {
    state = state.update(searchQuery: searchQuery);
  }

  void setSortOption(SortbyType sortOption) {
    state = state.update(sortOptions: sortOption);
  }
}

final filterOptionsProvider = StateNotifierProvider.autoDispose<FilterOptionsController, FilterOptions>((ref) => FilterOptionsController());
final tempFilterOptionProvider =
    StateNotifierProvider.autoDispose<FilterOptionsController, FilterOptions>((ref) => FilterOptionsController());
