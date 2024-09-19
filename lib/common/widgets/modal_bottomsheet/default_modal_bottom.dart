import 'package:flutter/material.dart';

class DefaultModalBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool fixedHeight;

  const DefaultModalBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.fixedHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: fixedHeight ? MediaQuery.of(context).size.height * 0.5 : null,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            title!,
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
                          ),
                        ),
                      )
                    ],
                  ),
                if (title != null)
                  const SizedBox(
                    height: 20,
                  ),
                child
              ],
            ),
          ),
        ),
      ),
    );
  }
}
