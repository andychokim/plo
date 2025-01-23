import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/providers/singlepost.dart';
import 'package:plo/common/widgets/custom_alert_box.dart';
import 'package:plo/common/widgets/custom_button.dart';
import 'package:plo/model/comments_model.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/model/types/report_comment_type.dart';
import 'package:plo/model/types/report_type.dart';
import 'package:plo/views/comments/comments_widget/single_comment_provider.dart';
import 'package:plo/views/postdetail_screen/report_screen/report_screen_comment/report_comment_controller.dart';
import 'package:plo/views/postdetail_screen/report_screen/report_screen_controller.dart';
import 'package:plo/views/postdetail_screen/report_screen/reportsuccessPage.dart';

final selectedReportTypeProvider = StateProvider.autoDispose<ReportCommentType>(
    (ref) => ReportCommentType.values.first);

class ReportCommentFormWidget extends ConsumerStatefulWidget {
  final CommentModel commentKey;
  final ScrollController scrollController;
  const ReportCommentFormWidget(
      {super.key, required this.scrollController, required this.commentKey});

  @override
  ConsumerState<ReportCommentFormWidget> createState() =>
      _ReportFormWidgetState();
}

class _ReportFormWidgetState extends ConsumerState<ReportCommentFormWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final etcDescriptionController = TextEditingController();
  final reportDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ReportCommentType selectedReportType =
        ref.watch(selectedReportTypeProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("신고 하는 이유가 무엇인가요?",
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: ReportCommentType.values.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final reportType = ReportCommentType.values[index];
            return RadioListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                activeColor: const Color.fromARGB(255, 128, 120, 120),
                title: Text(reportType.getDescription(),
                    style: Theme.of(context).textTheme.bodyMedium),
                value: reportType,
                groupValue: selectedReportType,
                onChanged: (value) {
                  ref.watch(selectedReportTypeProvider.notifier).state = value!;
                });
          },
        ),
        if (selectedReportType == ReportCommentType.etc)
          TextField(
            controller: etcDescriptionController,
            maxLines: 3,
            maxLength: 40,
            decoration: InputDecoration(
              hintText: "신고하는 이유를 간략하게 적어주세요.",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        const Divider(),
        const SizedBox(height: 10),
        Form(
          key: formKey,
          child: TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              maxLength: 200,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: reportDescriptionController,
              minLines: 8,
              maxLines: 8,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              onTap: () async {
                await Future.delayed(const Duration(milliseconds: 400));
                widget.scrollController.animateTo(
                    widget.scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut);
              },
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText:
                    "여기에 게시물을 신고하는 이유를 적어주세요. 자세한 설명은 신고된 게시물을 처리 할 때 도움이 됩니다.",
                focusColor: Colors.transparent,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              )),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.center,
          child: CustomButton(
            text: "신고하기",
            onPressed: () => showReportPopUp(context, selectedReportType, ref),
          ),
        ),
        const KeyboardPaddingWidget(),
      ],
    );
  }

  void showReportPopUp(BuildContext context,
      ReportCommentType selectedReportType, WidgetRef ref) async {
    bool? isConfirmed =
        await AlertBox.showYesOrNoAlertDialogue(context, "진짜로 신고 하시겠습니까?");
    if (isConfirmed == true) {
      final comment = ref.watch(singleCommentProvider(widget.commentKey));
      BuildContext loadingContext = context;
      showDialog(
        barrierDismissible: false,
        context: loadingContext,
        builder: (__) => const CircularProgressIndicator(),
      );
      final result = await ref
          .read(reportCommentControllerProvider.notifier)
          .uploadCommentReport(
              reportType: selectedReportType,
              comment: comment,
              formkey: formKey,
              etcDescription: etcDescriptionController.text,
              reportDescription: reportDescriptionController.text);
      log("upload report");
      Navigator.of(loadingContext).pop();
      if (result == false) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("신고를 하는 도중에 에러가 났습니다")));
      }
      if (result == true) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ReportSuccessPage()));
      }
    } else {
      Navigator.of(context).pop();
    }
  }
}

class KeyboardPaddingWidget extends StatelessWidget {
  const KeyboardPaddingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        bottom: bottomInset,
      ),
    );
  }
}
