import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../main.dart';

class StreamBuilderWidget extends StatelessWidget {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> stream;
  final Function(AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>) widget;
  const StreamBuilderWidget(
      {super.key, required this.stream, required this.widget});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Align(
            alignment: Alignment.topCenter,
            child: CircularProgressIndicator(
              color: constantSheet.colors.yellowlight,
            ),
          ).marginOnly(top: 30.h);
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return widget(snapshot);
          } else {
            return const SizedBox();
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
