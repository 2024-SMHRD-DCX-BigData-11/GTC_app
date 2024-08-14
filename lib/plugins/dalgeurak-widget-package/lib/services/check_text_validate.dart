class CheckTextValidate {
  bool validateIsOnlyHangeulStr(String value){
    if(value.isEmpty){
      return false;
    } else {
      String pattern = r'^[ㄱ-ㅎ|가-힣]+$';
      RegExp regExp = RegExp(pattern);
      if (regExp.hasMatch(value)){
        return true;
      } else{
        return false;
      }
    }
  }
}