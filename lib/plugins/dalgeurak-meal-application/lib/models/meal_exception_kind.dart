import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';

class MealExceptionKind {
  int? _weekDay;
  MealType? _mealType;
  MealExceptionType? _exceptionType;


  int? get weekDay => _weekDay;
  MealType? get mealType => _mealType;
  MealExceptionType? get exceptionType => _exceptionType;


  MealExceptionKind({
    required int? weekDay,
    required MealType? mealType,
    required MealExceptionType? exceptionType,
  }){
    _weekDay = weekDay;
    _mealType = mealType;
    _exceptionType = exceptionType;
}

  MealExceptionKind.fromJson(dynamic json) {
    _weekDay = json['weekDay'];
    _mealType = json['mealType'];
    _exceptionType = json['exceptionType'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['weekDay'] = _weekDay;
    map['mealType'] = _mealType;
    map['exceptionType'] = _exceptionType;
    return map;
  }

}