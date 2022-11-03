import 'package:flutter/material.dart';
import 'ItemPicWidget.dart';
import 'PicListAndPos.dart';

class PicPageWidget extends StatefulWidget {
  const PicPageWidget({Key? key}) : super(key: key);

  @override
  State<PicPageWidget> createState() => _PicPageWidgetState();
}

class _PicPageWidgetState extends State<PicPageWidget> {
  List<Widget> list = [];
  late PicListAndPos? listAndPos;
  late PageController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listAndPos = ModalRoute.of(context)?.settings.arguments as PicListAndPos?;
    setList();
    controller = PageController(initialPage: listAndPos!.position);
  }

  @override
  Widget build(BuildContext context) {
    if (listAndPos != null && listAndPos?.getNowPic().img != null) {
      return PageView(
        controller: controller,
        scrollDirection: Axis.vertical,
        children: list,
      );
    } else {
      return Container();
    }
  }

  setList() {
    List<Widget> w = [];
    if (listAndPos != null) {
      for (var pic in listAndPos!.list) {
        w.add(ItemPicWidget(path: pic.img.toString()));
      }
      setState(() {
        list = w;
      });
    }
  }
}
