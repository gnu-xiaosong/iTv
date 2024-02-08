/*
 * @Author: xskj
 * @Date: 2023-12-30 18:54:06
 * @LastEditors: xskj
 * @LastEditTime: 2023-12-30 21:52:07
 * @Description: test请求类
 */
import 'package:app_template/api/BasedApi.dart';

class VideoApi extends BasedApi {
  //请求视频类别列表页
  // static Future<dynamic> getVideoListByCategoryApi(int t) async {
  //   //获取dio实例化对象-单例模式
  //   HttpManager appHttp = GlobalManager().GlobalHttp;
  //   //发起请求
  //   String url = "/api.php/provide/vod";
  //   //請求參數
  //   Map<String, dynamic> params = {"ac": "list", "t": t, "pg": 1};
  //
  //   var res = await appHttp.api(url, parameters: params, method: METHODS.GET);
  //   print('==2=====');
  //   print("---------------------获取消息-----------------");
  //   print(res.toString());
  //   return res;
  // }
}
