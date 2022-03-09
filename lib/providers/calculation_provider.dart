import 'package:calculator/database/database_handler.dart';
import 'package:calculator/model/history.dart';
import 'package:calculator/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculationProvider extends ChangeNotifier {
  // use for show to user
  String _showExpression = '';
  // use for calculation
  String _expression = '';

  Color _expressionColor = kExpressionColor;

  String _result = '';

  ResultType _resultType = ResultType.dontHave;

  bool _haveDot = false;

  List<int> _operatorIndex = [];

  String get getExpression => _showExpression;
  String get getResult => _result;
  Color get getExpressionColor => _expressionColor;

  void setExpression(String exp) {
    _showExpression = exp;
    if (exp.startsWith(kMinusSymbol)) {
      _expression = '-' + exp.substring(1).replaceAll(',', '');
      _operatorIndex = [1];
    } else {
      _expression = exp.replaceAll(',', '');
      _operatorIndex = [];
    }
    _result = '';
    _haveDot = exp.contains('.');
    _resultType = ResultType.dontHave;
    _getExpressionColor();
    notifyListeners();
  }

  void deleteHistory() {
    DataBaseHandler().deleteHistory();
    notifyListeners();
  }

  String _addComma(String number) {
    // add comma between number for more readable
    if (number.isEmpty) {
      return '';
    }
    int i = number.length - 1;
    String n = '';
    if (number.contains('.')) {
      i = number.indexOf('.') - 1;
      n = number.substring(i + 1);
    }
    int j = 1;
    while (i > 0) {
      if (j % 3 == 0) {
        n = ',' + number[i] + n;
      } else {
        n = number[i] + n;
      }
      --i;
      ++j;
    }
    n = number[0] + n;
    return n;
  }

  void _addNumber(String number) {
    if (number == '.' && !_haveDot) {
      _haveDot = true;
    } else if (number == '.') {
      //if user press agian . don't add another .
      return;
    }
    if (_showExpression.isNotEmpty &&
        _showExpression[_showExpression.length - 1] == ')') {
      _showExpression += kMulSymbol;
      _expression += '*';
      _operatorIndex.add(_showExpression.length);
    }
    String n;
    if (_haveDot) {
      //don't add commna
      _showExpression += number;
      _expression += number;
    } else if (_operatorIndex.isEmpty) {
      // it's first number
      n = _showExpression
          .substring(0, _showExpression.length)
          // recomma
          .replaceAll(',', '');
      // check first digit
      if (n != '0') {
        n = _addComma(n + number);
        _expression += number;
      } else {
        //don't add extra zero to first
        n = number;
      }
      _showExpression = n;
      // beacuase this is first
      // don't have any symbol that library can not understand
    } else {
      // from last operator
      n = _showExpression.substring(_operatorIndex.last).replaceAll(',', '');
      // check first digit
      if (n != '0') {
        n = _addComma(n + number);
        _expression += number;
      } else {
        //don't add extra zero to first
        n = number;
      }
      _showExpression = _showExpression.substring(0, _operatorIndex.last) + n;
    }
  }

  void onNumClick(String text) {
    if (_resultType != ResultType.dontHave) {
      _showExpression = '';
      _expression = '';
      _result = '';
      _resultType = ResultType.dontHave;
      _getExpressionColor();
    }
    _addNumber(text);
    notifyListeners();
  }

  String _findOperator(String op) {
    // return equivalent operator for _expression
    // for library can understand it
    if (op == kAddSymbol) {
      return '+';
    } else if (op == kMinusSymbol) {
      return '-';
    } else if (op == kMulSymbol) {
      return '*';
    } else if (op == kDivSymbol) {
      return '/';
    } else if (op == '(') {
      return '(';
    } else {
      return ')';
    }
  }

  bool _isNumber(String n) {
    String numbers = '0123456789';
    for (int i = 0; i < numbers.length; ++i) {
      if (n == numbers[i]) {
        return true;
      }
    }
    return false;
  }

  void onOperatorClick(String text) {
    //except '='
    // if (_showExpression.isEmpty) {
    //   return;
    // }
    // evaluate(text);
    _haveDot = false;
    String op = _findOperator(text);

    if (op == '(' && _showExpression.isNotEmpty) {
      if (_operatorIndex.isEmpty ||
          _isNumber(_showExpression[_showExpression.length - 1])) {
        op = '*' + op;
        text = kMulSymbol + text;
        _operatorIndex.add(_showExpression.length + 1);
      }
    }
    if (_resultType == ResultType.correct) {
      //add result to expression
      _showExpression = _result + text;
      if (_result.startsWith(kMinusSymbol)) {
        _expression = '-' + _result.substring(1).replaceAll(',', '') + op;
        _operatorIndex = [1];
      } else {
        _expression = _result.replaceAll(',', '') + op;
        // _operatorIndex = [];
      }
      _result = '';
      _resultType = ResultType.dontHave;
      _getExpressionColor();
    } else {
      if (_resultType == ResultType.wrong) {
        _getExpressionColor();
      }
      if (_operatorIndex.isNotEmpty &&
          _showExpression.length == _operatorIndex.last &&
          op != '(' &&
          _showExpression[_operatorIndex.last - 1] != '(' &&
          _showExpression[_operatorIndex.last - 1] != ')') {
        _showExpression =
            _showExpression.substring(0, _showExpression.length - 1) + text;
        _expression = _expression.substring(0, _expression.length - 1) + op;
        _operatorIndex.removeLast();
      } else {
        _showExpression += text;
        _expression += op;
      }
    }
    _operatorIndex.add(_showExpression.length);
    notifyListeners();
  }

  String _decorationResult(String result) {
    String res = '';
    bool isNeg = result.startsWith('-');
    if (isNeg) {
      result = result.substring(1);
    }
    if (result.contains('.')) {
      int dotIndex = result.indexOf('.');
      String intPart = result.substring(0, dotIndex);
      intPart = _addComma(intPart);
      String floatPart = result.substring(dotIndex);
      if (floatPart == '.0') {
        floatPart = '';
      }
      res = intPart + floatPart;
    } else {
      res = _addComma(result);
    }
    if (isNeg) {
      res = kMinusSymbol + res;
    }

    return res;
  }

  void evaluate(String text) {
    String res = '';
    try {
      Parser p = Parser();
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      res = _decorationResult(eval.toString());
      _resultType = ResultType.correct;
      History history = History(expression: _showExpression, result: res);
      DataBaseHandler().insertHistory(history);
    } on RangeError {
      _resultType = ResultType.wrong;
      res = 'Wrong Format';
    } on FormatException {
      _resultType = ResultType.wrong;
      res = 'Wrong Format';
    }
    _operatorIndex = [];
    _haveDot = false;
    _showExpression += text;
    _result = res;
    _getExpressionColor();
    notifyListeners();
  }

  void backspace(String text) {
    //delete one character
    String e = '';
    String s = '';
    if (_resultType == ResultType.dontHave) {
      if (_showExpression.isNotEmpty) {
        s = _showExpression.substring(0, _showExpression.length - 1);
        e = _expression.substring(0, _expression.length - 1);

        if (_operatorIndex.isNotEmpty &&
            _showExpression.length == _operatorIndex.last) {
          // if last is an operator
          _operatorIndex.removeLast();
        }
        String n;
        if (_operatorIndex.isEmpty) {
          n = _showExpression.substring(0, _showExpression.length - 1);
          if (!n.contains('.')) {
            //if not a float part reset commas of number
            n = _addComma(n.replaceAll(',', ''));
          } else {
            _haveDot = false;
          }
          s = n;
        } else {
          n = _showExpression.substring(
              _operatorIndex.last, _showExpression.length - 1);
          if (!n.contains('.')) {
            //if not a float part reset commas of number
            n = _addComma(n.replaceAll(',', ''));
          }
          s = _showExpression.substring(0, _operatorIndex.last) + n;
        }
      }
    } else if (_resultType == ResultType.correct) {
      //if have result expression = result
      s = _result;
      if (_result.startsWith(kMinusSymbol)) {
        e = '-' + _result.substring(1).replaceAll(',', '');
        _operatorIndex = [1];
      } else {
        e = _result.replaceAll(',', '');
      }
      _resultType = ResultType.dontHave;
      _getExpressionColor();
    } else {
      s = '';
      e = '';
      _resultType = ResultType.dontHave;
      _getExpressionColor();
    }
    _showExpression = s;
    _expression = e;
    _result = '';
    notifyListeners();
  }

  void clear(String text) {
    _haveDot = false;
    _resultType = ResultType.dontHave;
    _showExpression = '';
    _expression = '';
    _operatorIndex = [];
    _result = '';
    _getExpressionColor();
    notifyListeners();
  }

  void _getExpressionColor() {
    Color c;
    if (_resultType == ResultType.dontHave) {
      c = kExpressionColor;
    } else {
      c = kExpressionColorAfterResult;
    }

    _expressionColor = c;
  }
}
