import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:jiffy/jiffy.dart';
import 'package:dalgeurak/controllers/bindings/main_binding.dart'; // MainBinding 클래스를 임포트합니다.
import 'package:provider/provider.dart';
import 'screens/game/game_provider.dart'; // GameProvider 경로 추가

// Firebase 설정 옵션 (웹에서 사용)
const FirebaseOptions firebaseOption = FirebaseOptions(
  apiKey: 'AIzaSyCiL45mXWuDWp9M7nQ_2lLxzZ3Gr_vEgUc',
  authDomain: 'gtcapp-673ed.firebaseapp.com',
  projectId: 'gtcapp-673ed',
  storageBucket: 'gtcapp-673ed.appspot.com',
  messagingSenderId: '981552705511',
  appId: '1:981552705511:web:b9f15e09dfe324391c9742',
  measurementId: 'G-SYX3J8X2H8',
);

// Dimigoin API 인증 토큰
const String dimigoStudentAPIAuthToken = "your-auth-token";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(options: firebaseOption);
  } else {
    await Firebase.initializeApp();
  }

  Get.put<RemoteConfigService>(RemoteConfigService());
  await DimigoinFlutterPlugin().initializeApp(dimigoStudentAPIAuthToken: dimigoStudentAPIAuthToken);
  DalgeurakWidgetPackage().initializeApp();
  SharedPreference();
  await Jiffy.locale("ko");

  if (!kIsWeb) {
    await Get.putAsync<UpgraderService>(() => UpgraderService().init());
  }

  NotificationController _notiController = Get.put<NotificationController>(NotificationController(), permanent: true);
  await _notiController.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()), // GameProvider 등록
        // 다른 Provider가 있다면 여기에 추가할 수 있습니다.
      ],
      child: MyApp(notiController: _notiController),
    ),
  );
}

class MyApp extends StatelessWidget {
  late NotificationController notiController;
  MyApp({required this.notiController});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
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
              radius: const Radius.circular(10),
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
          initialBinding: MainBinding(), // MainBinding을 여기서 사용합니다.
          getPages: DalgeurakMealApplicationPages.pages,
          home: Root(notiController: notiController),
        ),
      ),
      maximumSize: const Size(475.0, 812.0),
      enabled: false,
      backgroundColor: Colors.white,
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
