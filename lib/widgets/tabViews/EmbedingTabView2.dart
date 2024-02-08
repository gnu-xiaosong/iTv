/*
 * @Author: xskj
 * @Date: 2023-12-29 16:19:41
 * @LastEditors: xskj
 * @LastEditTime: 2023-12-30 12:42:13
 * @Description: home页 topTab切换视频标签
 */

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:animations/animations.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Row;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shaky_animated_listview/animators/grid_animator.dart';
import 'package:shaky_animated_listview/widgets/animated_listview.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_control_panel/video_player_control_panel.dart';

import 'package:video_player_media_kit/video_player_media_kit.dart';

import '../cards/image_card/lib/image_card.dart';
import 'package:sprintf/sprintf.dart';

var VideoController;

Widget _title({Color? color, required String name}) {
  return Text(
    name,
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color),
  );
}

Widget _content({Color? color}) {
  return Text(
    '',
    style: TextStyle(color: color),
  );
}

// Widget _footer({Color? color}) {
//   return Row(
//     children: [
//       CircleAvatar(
//         backgroundImage: AssetImage(
//           'assets/avatar.png',
//         ),
//         radius: 12,
//       ),
//       const SizedBox(
//         width: 4,
//       ),
//       Expanded(
//           child: Text(
//         'Super user',
//         style: TextStyle(color: color),
//       )),
//       IconButton(onPressed: () {}, icon: Icon(Icons.share))
//     ],
//   );
// }

Widget _tag(String tag, VoidCallback onPressed) {
  return InkWell(
    onTap: onPressed,
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Colors.green),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Text(
        tag,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}

Widget app1(Map data, BuildContext context) {
  Map data_item = data;
  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.topLeft,
        child: Text(
          data_item['name'],
          style: TextStyle(
              fontSize: 20,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold),
        ).animate().fade().tint(color: Colors.purple),
      ),
      StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: List.generate(
            data_item['data'].length,
            (i) => GridAnimatorWidget(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: MouseRegion(
                      onHover: (point) {
                        // print(point);
                      },
                      child: GestureDetector(
                        onTap: () {
                          //点击事件
                          print("点击电影:");
                          print(data_item['data'][i]);
                          //弹出窗口
                          showModal(
                            context: context,
                            builder: (context) => FluidDialog(
                              // Use a custom curve for the alignment transition
                              alignmentCurve: Curves.easeInOutCubicEmphasized,
                              // Setting custom durations for all animations.
                              sizeDuration: const Duration(milliseconds: 300),
                              alignmentDuration:
                                  const Duration(milliseconds: 600),
                              transitionDuration:
                                  const Duration(milliseconds: 300),
                              reverseTransitionDuration:
                                  const Duration(milliseconds: 50),
                              // Here we use another animation from the animations package instead of the default one.
                              transitionBuilder: (child, animation) =>
                                  FadeScaleTransition(
                                animation: animation,
                                child: child,
                              ),
                              // Configuring how the dialog looks.
                              defaultDecoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              // Setting the first dialog page.
                              rootPage: FluidDialogPage(
                                  alignment: Alignment.center,
                                  builder: (context) {
                                    List videos = [];
                                    String vodPlayUrl = data_item['data'][i]
                                            ['vod_play_url']
                                        .toString();
                                    if (vodPlayUrl != null &&
                                        vodPlayUrl.isNotEmpty) {
                                      List items_video = [];

                                      // 检查视频链接是否包含 #
                                      if (vodPlayUrl.contains("#")) {
                                        items_video = vodPlayUrl.split("#");
                                      } else {
                                        items_video = [vodPlayUrl];
                                      }

                                      // 格式化视频数据集合
                                      for (String item in items_video) {
                                        List item_1 = [];
                                        if (item.contains("\$")) {
                                          item_1 = item.split("\$");
                                        } else {
                                          item_1 = ["0", item];
                                        }
                                        videos.add({
                                          "name": item_1.length > 0
                                              ? item_1[0]
                                              : "", // 避免空指针异常
                                          "video_url": item_1.length > 1
                                              ? item_1[1]
                                              : "" // 避免空指针异常
                                        });
                                      }
                                    }

                                    return Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Text(data_item['data'][i]
                                                ['vod_name']),
                                            titleAlignment:
                                                ListTileTitleAlignment.center,
                                            leading: GestureDetector(
                                              onTap: () {
                                                //close
                                                VideoController.dispose();
                                                Navigator.pop(context);
                                              },
                                              child:
                                                  Icon(Icons.cancel_outlined),
                                            ),
                                            iconColor: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                          videoPlay(
                                              data_item['data'][i], videos)
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.grey,
                          //card item
                          child: TransparentImageCard(
                            width: 200,
                            height: 290,
                            imageProvider: data_item['data'][i]['vod_pic'],
                            tags: [
                              _tag(data_item['data'][i]['vod_class'], () {}),
                            ],
                            title: _title(
                                name: data_item['data'][i]['vod_name'],
                                color: Colors.white),
                            description: _content(color: Colors.white),
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          ).toList())
    ],
  );
}

String generateCaptionFileContent() {
  final sb = StringBuffer();
  for (int i = 1; i < 60 * 20; i++) {
    int minute = i ~/ 60;
    int second = i % 60;
    sb.writeln("$i");
    sb.writeln(sprintf("00:%02d:%02d,000 --> 00:%02d:%02d,900",
        [minute, second, minute, second]));
    sb.writeln("this is caption $i");
    sb.writeln("2nd line");
    sb.writeln("");
  }
  return sb.toString();
}

Widget videoPlay(Map data, List videos) {
  VideoPlayerMediaKit.ensureInitialized(
    android:
        true, // default: false    -    dependency: media_kit_libs_android_video
    iOS: true, // default: false    -    dependency: media_kit_libs_ios_video
    macOS:
        true, // default: false    -    dependency: media_kit_libs_macos_video
    windows:
        true, // default: false    -    dependency: media_kit_libs_windows_video
    linux: true, // default: false    -    dependency: media_kit_libs_linux
  );

  print("--------视频信息----------");
  print(videos);
  //视屏解析接口
  String video_jx = "https://jx.wolongzywcdn.com:65/m3u8.php?url=";
  String url = video_jx + videos[0]['video_url'];
  VideoController = VideoPlayerController.networkUrl(
    Uri.parse(url),
    videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
  );
  var captionFile =
      Future.value(SubRipCaptionFile(generateCaptionFileContent()));
  VideoController.setClosedCaptionFile(captionFile);

  VideoController.initialize().then((value) {
    if (!kIsWeb) VideoController.play();
  });

  return Expanded(
      child: Container(
          width: double.infinity,
          color: Colors.green,
          child: JkVideoControlPanel(
            VideoController,
            showClosedCaptionButton: true,
            showFullscreenButton: true,
            showVolumeButton: true,
          )));
}

//主页面组件
Widget Index(List data, BuildContext context) {
  return ListView(
    children: [
      // Container(
      //   width: double.infinity,
      //   height: 400,
      //   color: Colors.white,
      //   child: Swiper(
      //     index: 0,
      //     //当用户点击某个轮播的时候调用
      //     onTap: (index) {
      //       print(index);
      //     },
      //     //指示器
      //     indicatorLayout: PageIndicatorLayout.COLOR,
      //     //动画时间，单位是毫秒
      //     duration: 300,
      //     autoplay: true,
      //     //方向
      //     scrollDirection: Axis.horizontal,
      //     itemBuilder: (context, index) {
      //       // print("-----------------藉口---------------------");
      //       // print(data[index]['data'].runtimeType);
      //
      //       if (data.isNotEmpty && index >= 0 && index < data.length) {
      //         // 如果 data 列表不为空，并且 index 在有效范围内
      //         // 则执行轮播图的构建逻辑
      //         return Image.network(
      //           data[index]['data'][0]['vod_pic'],
      //           fit: BoxFit.fill,
      //         );
      //       } else {
      //         // 如果 data 列表为空，或者 index 超出了范围
      //         // 则返回一个占位的图片或者其他的处理方式
      //         return Placeholder(); // 或者返回其他的占位组件
      //       }
      //     },
      //     itemCount: data.length,
      //     viewportFraction: 0.8,
      //     scale: 0.9,
      //   ),
      // ),
      for (var item in data) app1(item, context)
    ],
  );
}

DynamicLibrary _openOnLinux() {
  // final scriptDir = File(Platform.script.toFilePath()).parent;
  final libraryNextToScript = File("assets/sqlite/sqlite3.dll");
  return DynamicLibrary.open(libraryNextToScript.path);
}

List getPageOfData(int pageNumber, int pageSize) {
  List<dynamic> _videoData = [];
  open.overrideFor(OperatingSystem.windows, _openOnLinux);

  final db = sqlite3.open('assets/database/App.db');
  List<Map> DataCategory = [];

  List<Map> DataPage = [];

  //获取类别
  final ResultSet resultSet = db.select('''SELECT vod_class, COUNT(*) AS count
      FROM tv_video
      GROUP BY vod_class''');
  for (final Row row in resultSet) {
    DataCategory.add({"name": row['vod_class'], "count": row['count']});
    print('${DataCategory}');
  }

  final offset = pageNumber * pageSize;
  //获取分页数据
  for (var item in DataCategory) {
    List _item = [];
    //查询分页
    ResultSet resultSet1 = db.select(
      'SELECT * FROM tv_video WHERE vod_class = ? LIMIT ? OFFSET ?',
      [item['name'].toString(), pageSize, offset],
    );
    for (final Row row in resultSet1) {
      _item.add(row);
      print('${row}');
    }
    //封装
    DataPage.add({"name": item['name'], "count": item["count"], "data": _item});
  }

  db.dispose();
  return DataPage;
}

//刷新控制器获取控制器
RefreshController _refreshController = RefreshController(initialRefresh: false);
void _onRefresh() async {
  // monitor network fetch
  await Future.delayed(const Duration(milliseconds: 1000));
  // if failed,use refreshFailed()
  _refreshController.refreshCompleted();
}

void _onLoading() async {
  // monitor network fetch
  await Future.delayed(const Duration(milliseconds: 1000));
  // if failed,use loadFailed(),if no data return,use LoadNodata()
  // items.add((items.length + 1).toString());
  // if (mounted) setState(() {});
  _refreshController.loadComplete();
}

class EmbedingTabView2 extends StatefulWidget {
  const EmbedingTabView2({super.key});

  @override
  State<EmbedingTabView2> createState() => _EmbedingTabView2State();
}

class _EmbedingTabView2State extends State<EmbedingTabView2> {
  List<dynamic> _videoData = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      _videoData = getPageOfData(1, 10);
      print(_videoData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Index(_videoData, context));
  }
}
