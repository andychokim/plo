enum CategoryType {
  general,
  information;

  @override
  String toString() {
    switch (this) {
      case CategoryType.information:
        return "information";
      case CategoryType.general:
        return "general";
      default:
        return "general";
    }
  }

  static stringToCategory(String string) {
    switch (string) {
      case "information":
        return CategoryType.information;
      case "general":
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
