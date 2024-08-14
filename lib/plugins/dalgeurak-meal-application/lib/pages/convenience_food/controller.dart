import 'package:dalgeurak_meal_application/pages/convenience_food/widgets/food_select_container.dart';
import 'package:dalgeurak_widget_package/widgets/toast.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ConvenienceFoodPageController extends GetxController with StateMixin {
  Rx<ConvenienceFoodType> selectConvenienceFoodType = ConvenienceFoodType.none.obs;
  Rx<MealType> selectMealType = MealType.breakfast.obs;

  DalgeurakService _dalgeurakService = DalgeurakService();
  DalgeurakToast _dalgeurakToast = DalgeurakToast();

  Map convenienceFoodMenuList = {
    MealType.breakfast: [ConvenienceFoodType.misu, ConvenienceFoodType.salad, ConvenienceFoodType.sandwich],
    MealType.dinner: [ConvenienceFoodType.misu, ConvenienceFoodType.salad],
  };

  RxMap convenienceFoodRemainAmount = {
    ConvenienceFoodType.misu: "-",
    ConvenienceFoodType.salad: "-",
    ConvenienceFoodType.sandwich: "-",
  }.obs;

  bool isCreateRefreshTimer = false;
  RxInt refreshTime = 0.obs;
  Rx<DateTime> lastRefreshTime = DateTime.now().obs;

  @override
  void onInit() {
    change(null, status: RxStatus.success());
    super.onInit();

    refreshTimer();
  }

  Future<void> refreshTimer() async {
    try {
      while (true) {
        await Future.delayed(
            Duration(seconds: 1),
                () async {
              if (refreshTime.value == 0) {
                bool result = await getConvenienceFoodRemainAmount(selectMealType.value);

                if (result) { lastRefreshTime.value = DateTime.now(); }

                refreshTime.value = 30;
              } else {
                refreshTime.value = refreshTime.value - 1;
              }
            }
        );
      }
    } catch (e) { //중간에 로그아웃 되서 타이머가 오류가 났을 경우
      isCreateRefreshTimer = false;
    }
  }

  applicationConvenienceFood() async {
    if (selectConvenienceFoodType.value == ConvenienceFoodType.none) { _dalgeurakToast.show("메뉴가 선택되지 않았습니다."); return; }

    Map result;
    if (DimigoinAccount().currentUser.userType != DimigoinUserType.teacher) {
      result = await _dalgeurakService.applicationConvenienceFood(selectMealType.value, selectConvenienceFoodType.value);
    } else {
      result = await _dalgeurakService.applicationTeacherConvenienceFood(Get.arguments['studentUid'], selectMealType.value, selectConvenienceFoodType.value);
    }

    if (result['success']) {
      _dalgeurakToast.show("신청에 성공하였습니다.");
      Get.back();
    } else {
      _dalgeurakToast.show(result['content']);
    }
  }

  getConvenienceFoodRemainAmount(MealType mealType) async {
    convenienceFoodRemainAmount.forEach((key, value) => convenienceFoodRemainAmount.update(key, (value) => "-"));


    Map result = await _dalgeurakService.getConvenienceFoodInfo();

    if(!(result['success'])) { _dalgeurakToast.show("남은 인원 불러오기에 실패하였습니다."); return false; }
    
    (result['content'] as List).forEach((element) {
      if ((element['time'] as String).convertMealType == mealType) {
        convenienceFoodRemainAmount.update((element['food'] as String).convertConvenienceFoodType, (value) => (element['remain'] as int).toString());
      }
    });


    return true;
  }

  changeMealTypeMenu(MealType mealType) {
    selectMealType.value = mealType;

    getConvenienceFoodRemainAmount(mealType);
  }
}
