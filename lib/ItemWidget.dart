import 'package:flutter/material.dart';
import 'package:flutterdemo/PicListAndPos.dart';

class ItemWidget extends StatefulWidget {
  const ItemWidget({
    Key? key,
    required this.listAndPos,
  }) : super(key: key);
  final PicListAndPos listAndPos;

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController scaleAnimController;
  late Animation<double> scale;
  late PicListAndPos listAndPos;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scaleAnimController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    scale = Tween(begin: 0.0, end: 1.0).animate(scaleAnimController);
    listAndPos = widget.listAndPos;
  }

  @override
  Widget build(BuildContext context) {
    scaleAnimController.forward();
    return Material(
      child: ScaleTransition(
        scale: scale,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(listAndPos.getNowPic().thumb.toString()),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              Navigator.of(context).pushNamed("pic", arguments: listAndPos);
            },
          ),
        ),
      ),
    );
  }
}
