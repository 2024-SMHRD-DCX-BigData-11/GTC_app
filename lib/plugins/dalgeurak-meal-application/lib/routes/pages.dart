import 'package:dalgeurak_meal_application/pages/exception_type_select/binding.dart';
import 'package:dalgeurak_meal_application/pages/exception_type_select/page.dart';
import 'package:dalgeurak_meal_application/pages/meal_cancel/binding.dart';
import 'package:dalgeurak_meal_application/pages/meal_cancel/page.dart';
import 'package:dalgeurak_meal_application/pages/page_list/page.dart';
import 'package:dalgeurak_meal_application/routes/routes.dart';
import 'package:get/get.dart';

import '../pages/convenience_food/binding.dart';
import '../pages/convenience_food/page.dart';
import '../pages/meal_exception/binding.dart';
import '../pages/meal_exception/page.dart';

class DalgeurakMealApplicationPages {
  static final pages = [
    GetPage(name: DalgeurakMealApplicationRoutes.PAGELIST, page: () => const PageListPage()),
    GetPage(name: DalgeurakMealApplicationRoutes.CONVENIENCEFOOD, page: () => const ConvenienceFoodPage(), binding: ConvenienceFoodPageBinding()),
    GetPage(name: DalgeurakMealApplicationRoutes.MEALCANCEL, page: () => const MealCancelPage(), binding: MealCancelPageBinding()),
    GetPage(name: DalgeurakMealApplicationRoutes.MEALEXCEPTION, page: () => const MealExceptionPage(), binding: MealExceptionPageBinding()),
    GetPage(name: DalgeurakMealApplicationRoutes.MEALEXCEPTIONTYPESELECT, page: () => const MealExceptionTypeSelectPage(), binding: MealExceptionTypeSelectPageBinding()),
  ];
}
