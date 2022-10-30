import 'Picture.dart';

class PicListAndPos {
 final List<Vertical> list;
  final int position;

  PicListAndPos(this.list, this.position);
  Vertical getNowPic(){
    return list[position];
  }
}
