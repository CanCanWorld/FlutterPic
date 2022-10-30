import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'MyGridViewWidget.dart';
import 'PicPageWidget.dart';
import 'Category.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: const HomePageWidget(),
      routes: <String, WidgetBuilder>{
        "pic": (context) => const PicPageWidget(),
      },
      scrollBehavior: MyCustomScrollBehavior(),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  List<CategoryX> categories = [];
  List<Widget> gridViews = [];

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: PageView(
        onPageChanged: (int index) {
          print('$index');
        },
        children: gridViews,
      ),
    );
  }

  void getCategory() async {
    String path = "http://service.picasso.adesk.com/v1/vertical/category";
    var map = <String, dynamic>{};
    map["adult"] = false;
    map["first"] = 1;
    Dio dio = Dio();
    var response = await dio.get(path, queryParameters: map);
    Map<String, dynamic> json = response.data;
    Category category = Category.fromJson(json);
    if (category.res != null && category.res?.category != null) {
      setState(() {
        categories.clear();
        categories.addAll(category.res!.category!);
      });
      buildGridView();
    }
  }

  void buildGridView() {
    List<Widget> g = [];
    for (var category in categories) {
      g.add(MyGridViewWidget(category: category.id.toString()));
    }
    setState(() {
      gridViews = g;
    });
  }
}
