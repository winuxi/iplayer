import 'dart:ui';

const baseUrl = "https://app.et/devtest/list.json";
Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}