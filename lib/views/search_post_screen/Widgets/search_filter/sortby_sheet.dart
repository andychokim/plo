import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/utils/log_util.dart';
import 'package:plo/common/widgets/default_button_widget.dart';

import '../../../../common/widgets/modal_bottomsheet/default_modal_bottom.dart';
import '../../../../model/types/sortby_type.dart';
import '../../Controllers/filter_options_controller.dart';

final tempGroupValueProvider = StateProvider.autoDispose<SortbyType>((ref) => SortbyType.likes);

class SortByBottomsheet extends ConsumerStatefulWidget {
  final bool isFromSearchResultScreen;
  const SortByBottomsheet({super.key, this.isFromSearchResultScreen = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SortByBottomsheetState();
}

class _SortByBottomsheetState extends ConsumerState<SortByBottomsheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        ref.watch(tempGroupValueProvider.notifier).state = widget.isFromSearchResultScreen
            ? ref.watch(filterOptionsProvider).sortOptions
            : ref.watch(tempFilterOptionsProvider).sortOptions;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupValue = ref.watch(tempGroupValueProvider);
    // logToConsole("SortbyType.values is: ${SortbyType.values}");
    return DefaultModalBottomSheet(
      title: "정렬 기준",
      child: Column(
        children: [
          ...SortbyType.values.map(
            (sortbyType) {
              return SortByRadioButtonWidget(sortbyType: sortbyType, groupValue: groupValue);
            },
          ).toList(),
          const SizedBox(height: 30),
          DefaultButtonWidget(
            text: "적용",
            onPressed: () {
              widget.isFromSearchResultScreen
                  ? ref.watch(filterOptionsProvider.notifier).setSortOption(groupValue)
                  : ref.watch(tempFilterOptionsProvider.notifier).setSortOption(groupValue);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class SortByRadioButtonWidget extends ConsumerWidget {
  final SortbyType sortbyType;
  final SortbyType groupValue;
  const SortByRadioButtonWidget({super.key, required this.sortbyType, required this.groupValue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Radio(
          value: sortbyType,
          groupValue: groupValue,
          onChanged: (value) {
            ref.watch(tempGroupValueProvider.notifier).state = value as SortbyType;
          },
        ),
        Text(
          sortbyType.toString(),
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
