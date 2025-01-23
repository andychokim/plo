import 'package:plo/common/widgets/modal_bottomsheet/default_modal_bottom.dart';
import 'package:plo/views/post_write/post_write_controller.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateEditPostImage extends ConsumerWidget {
  const CreateEditPostImage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultModalBottomSheet(
      title: "옵션",
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text("카메라"),
            onTap: () {
              ref
                  .read(createEditPostStateController.notifier)
                  .pickImageFromCamera();
              Navigator.of(context).pop();
            }),
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text("갤러리"),
          onTap: () {
            ref
                .read(createEditPostStateController.notifier)
                .pickMultipleImagesFromGallery();
            Navigator.of(context).pop();
          },
        )
      ]),
    );
  }
}
