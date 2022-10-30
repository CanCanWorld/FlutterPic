import 'package:flutter/material.dart';
import 'package:flutterdemo/ItemPicWidget.dart';
import 'package:flutterdemo/PicListAndPos.dart';

class PicPageWidget extends StatefulWidget {
  const PicPageWidget({Key? key}) : super(key: key);

  @override
  State<PicPageWidget> createState() => _PicPageWidgetState();
}

class _PicPageWidgetState extends State<PicPageWidget> {
  List<Widget> list = [];
  late PicListAndPos? listAndPos;
  late PageController controller;
  double offset = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    listAndPos = ModalRoute.of(context)?.settings.arguments as PicListAndPos?;
    setList();
    controller = PageController(initialPage: listAndPos!.position);
    controller.addListener(() {
      offset = controller.offset;
      print('$offset');
    });
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
        w.add(ItemPicWidget(path: pic.img.toString(), offset: offset,));
      }
      setState(() {
        list = w;
      });
    }
  }
}
