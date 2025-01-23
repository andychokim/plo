import 'package:flutter/material.dart';

class NoCommentsFound extends StatelessWidget {
  final String message;
  const NoCommentsFound({super.key, this.message = "댓글이 존재하지 않습니다"});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 30),
            FittedBox(
              child: Text(
                message,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );

    ;
  }
}
