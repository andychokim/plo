import '../../constants/algolia_constants.dart';

enum SortbyType {
  newest,
  views,
  likes;

  @override
  String toString() {
    switch (this) {
      case SortbyType.newest:
        return "최신순";
      case SortbyType.views:
        return "조회순";
      case SortbyType.likes:
        return "좋아요순";
      default:
        return "최신순";
    }
  }

  static SortbyType stringToSortybyType(String? string) {
    switch (string) {
      case "최신순":
        return SortbyType.newest;
      case "조회순":
        return SortbyType.views;
      case "좋아요순":
        return SortbyType.likes;
      default:
        return SortbyType.newest;
    }
  }

  String sortByAlgoliaIndexName() {
    switch (this) {
      case SortbyType.newest:
        return AlgoliaConstants.sortByNewestIndexName;
      case SortbyType.views:
        return AlgoliaConstants.sortByViewsIndexName;
      case SortbyType.likes:
        return AlgoliaConstants.sortByLikesIndexName;
      default:
        return AlgoliaConstants.sortByNewestIndexName;
    }
  }
}
