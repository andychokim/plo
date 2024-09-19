enum CategoryType {
  general,
  information;

  @override
  String toString() {
    switch (this) {
      case CategoryType.information:
        return "정보";
      case CategoryType.general:
        return "자유";
      default:
        return "자유";
    }
  }

  static stringToCategory(String string) {
    switch (string) {
      case "정보":
        return CategoryType.information;
      case "자유":
        return CategoryType.general;
      default:
        return CategoryType.general;
    }
  }

  // static bool isAllSelected(List<CategoryType> categoryList) {
  //   return listEquals(categoryList, CategoryType.categoryOptions);
  // }

  static const List<CategoryType> categoryOptions = [
    CategoryType.general,
    CategoryType.information,
  ];
}
