import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/PicListAndPos.dart';

import 'ItemWidget.dart';
import 'Picture.dart';

class MyGridViewWidget extends StatefulWidget {
  const MyGridViewWidget({Key? key, required this.category}) : super(key: key);

  final String? category;

  @override
  State<MyGridViewWidget> createState() => _MyGridViewWidgetState();
}

class _MyGridViewWidgetState extends State<MyGridViewWidget> {
  ScrollController scrollController = ScrollController();
  List<Vertical> pics = [];
  List<Widget> widgets = [];
  int page = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getRequest();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print('bottom');
        getMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: RefreshIndicator(
          onRefresh: onRefresh,
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: .6,
            ),
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            children: widgets,
          )),
    );
  }

  Future onRefresh() async {
    await Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        page = 1;
      });
      getRequest();
    });
  }

  Future getMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 1), () {
        print('more');
        setState(() {
          page++;
          isLoading = false;
        });
        getRequest();
      });
    }
  }

  void getRequest() async {
    int random = Random.secure().nextInt(1000);
    print('random: $random');
    var dio = Dio();
    String path =
        "http://service.picasso.adesk.com/v1/vertical/category/${widget.category}/vertical";
    var map = <String, dynamic>{};
    map["limit"] = 30;
    map["skip"] = random;
    map["adult"] = false;
    map["first"] = 1;
    map["order"] = "new";
    var response = await dio.get(path, queryParameters: map);
    Map<String, dynamic> json = response.data;
    Picture picture = Picture.fromJson(json);
    if (picture.res != null && picture.res?.vertical != null) {
      setState(() {
        if (page == 1) {
          pics.clear();
        }
        pics.addAll(picture.res!.vertical!);
      });
      buildWidget();
    } else {}
  }

  void buildWidget() {
    List<Widget> w = [];
    w.clear();
    for (int i = 0; i < pics.length; i++) {
      PicListAndPos listAndPos = PicListAndPos(pics, i);
      w.add(ItemWidget(listAndPos: listAndPos));
    }
    setState(() {
      widgets = w;
    });
  }
}
