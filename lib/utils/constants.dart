import 'package:flutter/material.dart';

const kDivSymbol = '÷';
const kMulSymbol = '⨯';
const kMinusSymbol = '−';
const kAddSymbol = '+';
const kBackSymbol = '⌫';

const kAppBarColor = Color(0xff3392ff);
const kOperatorButtonColor = Color(0xffb3d6ff);
const kBackgroundColor = Color(0xfff0f0f5);
const kExpressionColor = Color(0xff000000);
const kExpressionColorAfterResult = Color(0xaa000000);

const kExpressionTextStyle = TextStyle(
  fontSize: 25,
);

const kResultTextStyle = TextStyle(
  fontSize: 25,
);

enum ResultType {
  dontHave,
  correct,
  wrong,
}
