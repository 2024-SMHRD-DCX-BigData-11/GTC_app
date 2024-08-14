import 'package:dalgeurak_meal_application/routes/pages.dart';
import 'package:dalgeurak_meal_application/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GetMaterialApp(
      getPages: DalgeurakMealApplicationPages.pages,
      initialRoute: DalgeurakMealApplicationRoutes.PAGELIST,
    ),
  );
}