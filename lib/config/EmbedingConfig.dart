//tab
import 'package:flutter/material.dart';
import '../widgets/tabViews/EmbedingTabView1.dart';
import '../widgets/tabViews/EmbedingTabView2.dart';

//页面结构: page->EmbedHome  basic->EmbedHome
bool isBasicLayout = true;
//是否显示appbar
bool isShowAppBar = true;

//指示器颜色
Color indicatorColor = Colors.lightBlue.shade100;

//导航栏高度
int space = 2;

//导航栏是否在侧边
bool isLeft = false;

//导航栏宽度
double tabBarWidth = 400;

//tabs
List tabs = [
  {
    "title": "home",
    "icon": const Icon(Icons.home),
    "select_icon": const Icon(
      Icons.home,
      color: Colors.blue,
    ),
    "body": EmbedingTabView1(),
  },
  {
    "title": "video",
    "icon": const Icon(Icons.slow_motion_video),
    "select_icon": const Icon(
      Icons.slow_motion_video,
      color: Colors.blue,
    ),
    "body": EmbedingTabView2(),
  },
  {
    "title": "music",
    "icon": const Icon(Icons.music_note),
    "select_icon": const Icon(
      Icons.music_note,
      color: Colors.blue,
    ),
    "body": EmbedingTabView1(),
  },
  {
    "title": "setting",
    "icon": const Icon(Icons.settings),
    "select_icon": const Icon(
      Icons.settings,
      color: Colors.blue,
    ),
    "body": EmbedingTabView2(),
  },
];
