// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:plo/common/widgets/custom_app_bar.dart';
// import 'package:plo/constants/firebase_contants.dart';
// import 'package:plo/views/settings_screen/settings_controller.dart';
// import 'package:plo/views/settings_screen/widgets/postcard.dart';

// class SavedPostScreen extends StatefulWidget {
//   const SavedPostScreen({super.key});

//   @override
//   State<SavedPostScreen> createState() => _SavedPostScreenState();
// }

// class _SavedPostScreenState extends State<SavedPostScreen> {
//   final _controller = ScrollController();
//   DocumentSnapshot? lastDocument;
//   List<DocumentSnapshot> documentList = [];

//   @override
//   void initState() {
//     super.initState();
//     getPosts(FirebaseConstants.savedRecordscollectionName, lastDocument,
//         documentList);
//     _controller.addListener(() {
//       if (_controller.position.pixels == _controller.position.maxScrollExtent) {
//         getPosts(FirebaseConstants.savedRecordscollectionName, lastDocument,
//             documentList);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const BackButtonAppBar(title: "저장한 게시물"),
//       body: ListView.builder(
//         itemCount: documentList.length,
//         itemBuilder: (context, index) => PostCard(
//           snap: documentList[index].data(),
//         ),
//         controller: _controller,
//       ),
//     );
//   }
// }
