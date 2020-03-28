import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:milk/model/constant.dart';
import 'package:milk/routers/application.dart';
import 'package:milk/routers/routers.dart';
import 'package:milk/provider/provider_manager.dart';
import 'package:milk/utils/storage_manager.dart';
import 'package:milk/views/splash_page.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'model/local_model.dart';
import 'model/theme_model.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await StorageManager.init();
  runApp(MyApp());
  // 透明状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}


class MyApp extends StatelessWidget {
  MyApp(){
    final router = new Router();
    Routes.configureRoutes(router);
    Application.router=router;
    initPlatformState();
  }

  final JPush jpush = new JPush();

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {},
          onOpenNotification: (Map<String, dynamic> message) async {},
          onReceiveMessage: (Map<String, dynamic> message) async {},
          onReceiveNotificationAuthorization:
          (Map<String, dynamic> message) async {}
          );
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    jpush.setup(
      appKey: "72c8c0e52d250a101d2d3105", //你自己应用的 AppKey
      channel: "developer-default",
      production: false,
      debug: true,
    );
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // Platform messages may fail, so we use a try/catch PlatformException.

    jpush.getRegistrationID().then((rid) {
      Constant.registrationID=rid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: MultiProvider(
            providers: providers,
            child: Consumer2<ThemeModel, LocaleModel>(
                builder: (context, themeModel, localeModel, child) {
                  return MaterialApp(
                    title: 'titles',
                    theme: themeModel.themeData(),
                    darkTheme: themeModel.themeData(isDarkMode: true),
                    locale: localeModel.locale,
                    home: SplashPage(),
                    debugShowCheckedModeBanner: false,
                    onGenerateRoute: Application.router.generator,
                  );
                }
                )
        )
    );
  }
}
