import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/widgets/default_button_widget.dart';
import 'package:plo/model/state_model/search_filter_options_model.dart';
import 'package:plo/views/search_post_screen/Widgets/search_filter/category_sheet.dart';

import '../../../../common/widgets/custom_gridview.dart';
import '../../Controllers/filter_options_controller.dart';
import 'sortby_sheet.dart';

class FilterSideBar extends ConsumerStatefulWidget {
  final FilterOptions tempFilterOptions;
  const FilterSideBar({super.key, required this.tempFilterOptions});

  @override
  ConsumerState<FilterSideBar> createState() => _FilterPageState();
}

class _FilterPageState extends ConsumerState<FilterSideBar> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tempFilterOptionsProvider.notifier).setFilterOptions(widget.tempFilterOptions);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tempFilterOptions = ref.watch(tempFilterOptionsProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "검색 필터",
                    ),
                    // spacing
                    FilterOptionWidget(
                      filterTitle: "정렬 기준",
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          showDragHandle: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          context: context,
                          builder: (context) => const SortByBottomsheet(),
                        );
                      },
                      filterStatusWidget: FilterStatusWidget(
                        filterStatusList: [tempFilterOptions.sortOptions.toString()],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FilterOptionWidget(
                      filterTitle: "카테고리",
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          showDragHandle: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          context: context,
                          builder: (context) => const CategoryBottomSheet(),
                        );
                      },
                      filterStatusWidget: FilterStatusWidget(
                        filterStatusList: tempFilterOptions.categorySelected.map((e) => e.toString().split('.').last).toList(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    DefaultButtonWidget(
                      text: "필터 리셋",
                      onPressed: () {
                        final searchQuery = tempFilterOptions.searchQuery;
                        ref.read(tempFilterOptionsProvider.notifier).setFilterOptions(FilterOptions(searchQuery: searchQuery));
                      },
                    ),
                    const SizedBox(height: 15),
                    DefaultButtonWidget(
                      text: "필터 적용",
                      onPressed: () {
                        ref.read(filterOptionsProvider.notifier).setFilterOptions(tempFilterOptions);
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FilterOptionWidget extends StatelessWidget {
  final String filterTitle;
  final Function onPressed;
  final Widget? filterStatusWidget;
  const FilterOptionWidget({super.key, required this.filterTitle, required this.onPressed, this.filterStatusWidget});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide()),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(filterTitle),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
            if (filterStatusWidget != null) filterStatusWidget!,
          ],
        ),
      ),
    );
  }
}

class FilterStatusWidget extends StatelessWidget {
  final List<String> filterStatusList;
  const FilterStatusWidget({super.key, required this.filterStatusList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          height: 30,
        ),
        itemCount: filterStatusList.length,
        itemBuilder: (context, index) {
          return FilterStatusSingleItemWidget(filterStatus: filterStatusList[index]);
        },
      ),
    );
  }
}

class FilterStatusSingleItemWidget extends StatelessWidget {
  final String filterStatus;
  const FilterStatusSingleItemWidget({super.key, required this.filterStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey[300]),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          filterStatus,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }
}
