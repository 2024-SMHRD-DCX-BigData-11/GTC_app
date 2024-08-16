import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dalgeurak/controllers/notification_controller.dart';
import 'package:dalgeurak/services/remote_config.dart';
import 'package:dalgeurak/services/shared_preference.dart';
import 'package:dalgeurak/services/upgrader.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/utils/root.dart';
import 'package:dalgeurak_meal_application/routes/pages.dart';
import 'package:dalgeurak_widget_package/dalgeurak_widget_package.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:jiffy/jiffy.dart';
import 'package:dalgeurak/controllers/bindings/main_binding.dart';

// Firebase 설정 옵션 (웹에서 사용)
const FirebaseOptions FIREBASEOPTION = FirebaseOptions(
  apiKey: "your-api-key",
  appId: "your-app-id",
  messagingSenderId: "your-messaging-sender-id",
  projectId: "your-project-id",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  if (kIsWeb) {
    await Firebase.initializeApp(options: FIREBASEOPTION);
  } else {
    await Firebase.initializeApp();
  }

  // 서비스 초기화
  Get.put<RemoteConfigService>(RemoteConfigService());
  await DimigoinFlutterPlugin().initializeApp(dimigoStudentAPIAuthToken: "your-auth-token");
  DalgeurakWidgetPackage().initializeApp();
  SharedPreference();
  await Jiffy.locale("ko");

  // Upgrader 서비스 초기화 (웹이 아닌 경우)
  if (!kIsWeb) {
    await Get.putAsync<UpgraderService>(() => UpgraderService().init());
  }

  // Notification Controller 초기화
  NotificationController _notiController = Get.put<NotificationController>(NotificationController(), permanent: true);
  await _notiController.initialize();

  runApp(MyApp(notiController: _notiController));
}

class MyApp extends StatelessWidget {
  final NotificationController notiController;
  MyApp({required this.notiController});

  @override
  Widget build(BuildContext context) {
    // 상태 표시줄 스타일 설정
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return FlutterWebFrame(
      builder: (context) => FGBGNotifier(
        onEvent: (event) {
          notiController.serviceWorkType.value = event;
        },
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "달그락",
          theme: ThemeData(
            accentColor: yellowFive,
            scrollbarTheme: ScrollbarThemeData(
              isAlwaysShown: true,
              thickness: MaterialStateProperty.all(6),
              thumbColor: MaterialStateProperty.all(yellowOne.withOpacity(0.8)),
              radius: Radius.circular(10),
              minThumbLength: 60,
            ),
          ),
          builder: (context, child) => Scaffold(
            body: GestureDetector(
              onTap: () {
                hideKeyboard(context);
              },
              child: child,
            ),
          ),
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
          ],
          initialBinding: MainBinding(),
          getPages: DalgeurakMealApplicationPages.pages,
          home: Root(notiController: notiController),
        ),
      ),
      maximumSize: Size(475.0, 812.0),
      enabled: false,
      backgroundColor: Colors.white,
    );
  }

  // 키보드 숨김 처리
  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
