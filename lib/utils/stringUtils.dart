String getParticle(String word) {
  // 한글 음절의 유니코드 범위
  const int base = 0xAC00; // 한글 음절의 시작 유니코드
  const int end = 0xD7A3; // 한글 음절의 끝 유니코드
  const int syllableCount = 11172; // 한글 음절의 총 개수
  const int initialConsonantCount = 19; // 초성 개수
  const int medialVowelCount = 21; // 중성 개수
  const int finalConsonantCount = 28; // 종성 개수

  // 마지막 음절의 유니코드 값
  int code = word.runes.last;

  if (code < base || code > end) {
    return '을'; // 한글 음절이 아닌 경우 기본적으로 '을'을 사용
  }

  // 음절을 초성, 중성, 종성으로 분해
  int syllableIndex = code - base;
  int finalConsonantIndex = syllableIndex % finalConsonantCount;

  // 종성이 있는지 확인
  if (finalConsonantIndex == 0) {
    return '를'; // 종성이 없는 경우
  } else {
    return '을'; // 종성이 있는 경우
  }
}