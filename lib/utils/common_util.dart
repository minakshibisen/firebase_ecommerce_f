
num stringToNumber(String numberS) {
  num number;
  try {
    number = int.tryParse(numberS) ?? 0;
  } catch (e) {
    number = 0;
  }
  return number;
}