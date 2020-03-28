
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:milk/model/constant.dart';
import 'package:milk/routers/fluro_navigator.dart';
import 'package:milk/utils/image_utils.dart';
import 'package:milk/utils/storage_manager.dart';
import 'package:milk/widgets/load_image.dart';
import 'package:rxdart/rxdart.dart';

import 'login/login_router.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int _status=0;
  List<String> _guideList = ['app_start_1', 'app_start_2', 'app_start_3'];
  StreamSubscription _subscription;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (StorageManager.sharedPreferences.getBool(Constant.keyGuide)??true) {
        /// 预先缓存图片，避免直接使用时因为首次加载造成闪动
        _guideList.forEach((image) {
          precacheImage(ImageUtils.getAssetImage(image), context);
        });
      }
      _initSplash();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _initGuide() {
    setState(() {
      _status = 1;
    });
  }
  void _initSplash(){

    _subscription = Observable.just(1).delay(Duration(milliseconds: 1500)).listen((_) {
      if (StorageManager.sharedPreferences.getBool(Constant.keyGuide)??true) {
        StorageManager.sharedPreferences.setBool(Constant.keyGuide, false);
        _initGuide();
      } else {
        _goLogin();
      }
    });
  }
  _goLogin() {
    NavigatorUtils.push(context, LoginRouter.loginPage, replace: true);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: _status == 0 ? FractionallyAlignedSizedBox(
            heightFactor: 0.3,
            widthFactor: 0.33,
            leftFactor: 0.33,
            bottomFactor: 0,
            child: const LoadAssetImage('logo')
        ) :
        Swiper(
          key: const Key('swiper'),
          itemCount: _guideList.length,
          loop: false,
          itemBuilder: (_, index) {
            return LoadAssetImage(
              _guideList[index],
              key: Key(_guideList[index]),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            );
          },
          onTap: (index) {
            if (index == _guideList.length - 1) {
              _goLogin();
            }
          },
        )
    );
  }

}