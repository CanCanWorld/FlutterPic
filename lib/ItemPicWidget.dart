import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class ItemPicWidget extends StatefulWidget {
  const ItemPicWidget({Key? key, required this.path, required this.offset}) : super(key: key);
  final String path;
  final double offset;

  @override
  State<ItemPicWidget> createState() => _ItemPicWidgetState();
}

class _ItemPicWidgetState extends State<ItemPicWidget> {
  late BuildContext ctx;
  String progress = "";
  late FToast toast;

  @override
  void initState() {
    super.initState();
    toast = FToast();
    toast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.path),
              fit: BoxFit.cover,
            ),
          ),
          child: Builder(
            builder: (BuildContext context) {
              ctx = context;
              return MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                onLongPress: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          )),
      endDrawer: Container(
        color: Colors.transparent,
        width: width,
        margin: EdgeInsets.fromLTRB(width / 3, height * 0.8, width / 3, 0),
        child: TextButton(
          onPressed: () {
            downloadPic(widget.path);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                const Color.fromARGB(30, 255, 255, 255)),
            side: MaterialStateProperty.all(const BorderSide(
              color: Colors.white,
              width: 1,
            )),
          ),
          child: Text(
            "下载$progress",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
      ),
    );
  }

  void downloadPic(String url) async {
    var platform = Theme.of(context).platform;
    print(platform);
    Directory? dirPath;
    switch (platform) {
      case TargetPlatform.android:
        dirPath = await getExternalStorageDirectory();
        break;
      case TargetPlatform.fuchsia:
        break;
      case TargetPlatform.iOS:
        break;
      case TargetPlatform.linux:
        break;
      case TargetPlatform.macOS:
        break;
      case TargetPlatform.windows:
        dirPath = await getApplicationDocumentsDirectory();
        break;
      default:
        break;
    }
    if (dirPath != null) {
      String path = "${dirPath.path}/LSP";
      print(path);
      var dir = Directory(path);
      if (dir.existsSync()) {
        print('文件夹已存在');
      } else {
        var result = dir.create(recursive: true);
        print('创建$result');
      }
      Dio dio = Dio();
      String savePath = "$path/lsp_"
          "${DateTime.now().year}_"
          "${DateTime.now().month}_"
          "${DateTime.now().day}_"
          "${DateTime.now().hour}"
          "${DateTime.now().minute}"
          "${DateTime.now().second}.jpg";
      dio.download(url, savePath, onReceiveProgress: (received, total) {
        if (total != -1) {
          setState(() {
            progress = "${(received / total * 100).toStringAsFixed(0)}%";
            print(progress);
            if (progress == "100%") {
              Scaffold.of(ctx).closeEndDrawer();
              toast.showToast(
                  child: const Text(
                "下载成功",
                style: TextStyle(
                  color: Colors.white,
                ),
              ));
            }
          });
        }
      });
    }
  }
}
