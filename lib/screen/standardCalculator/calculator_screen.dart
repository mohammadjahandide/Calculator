import 'package:flutter/material.dart';
import 'package:calculator/screen/components/calculator_button.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:calculator/constants.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // use for show to user
  String _showExpression = '';
  Color _expressionColor = kExpressionColor;

  // use for calculate
  String _expression = '';

  String _result = '';

  ResultType _resultType = ResultType.dontHave;

  bool _haveDot = false;

  List<int> _operatorIndex = [];

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
      //don't add another dot
      return;
    }
    _expression += number;
    String n;
    setState(() {
      if (_haveDot) {
        //don't add commna
        setState(() {
          _showExpression += number;
        });
      } else if (_operatorIndex.isEmpty) {
        // it's first number
        n = _showExpression
            .substring(0, _showExpression.length)
            .replaceAll(',', '');
        // remove commas first, add comma agian
        if (n != '0') {
          n = _addComma(n + number);
        } else {
          //don't add extra zero to first
          n = number;
        }
        _showExpression = n;
      } else {
        // form last operator
        n = _showExpression.substring(_operatorIndex.last).replaceAll(',', '');
        if (n != '0') {
          n = _addComma(n + number);
        } else {
          //don't add extra zero to first
          n = number;
        }
        _showExpression = _showExpression.substring(0, _operatorIndex.last) + n;
      }
    });
  }

  void _onNumClick(String text) {
    if (_resultType != ResultType.dontHave) {
      setState(() {
        _showExpression = '';
        _result = '';
      });
      _resultType = ResultType.dontHave;
      _getExpressionColor();
    }
    _addNumber(text);
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

  void _onOperatorClick(String text) {
    //except '='
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
      _expression = _result + op;
      setState(() {
        _showExpression = _result + text;
        _result = '';
        _resultType = ResultType.dontHave;
      });
      _getExpressionColor();
    } else {
      if (_resultType == ResultType.wrong) {
        _getExpressionColor();
      }
      _expression += op;
      setState(() {
        _showExpression += text;
      });
    }
    _operatorIndex.add(_showExpression.length);
  }

  String _decorationResult(String result) {
    String res = '';
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

    return res;
  }

  void _evaluate(String text) {
    String res = '';
    try {
      Parser p = Parser();
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      res = _decorationResult(eval.toString());
      _resultType = ResultType.correct;
    } on RangeError {
      _resultType = ResultType.wrong;
      res = 'Wrong Format';
    } on FormatException {
      _resultType = ResultType.wrong;
      res = 'Wrong Format';
    }
    _expression = '';
    _operatorIndex = [];
    _haveDot = false;
    setState(() {
      _showExpression += text;
      _result = res;
    });
    _getExpressionColor();
  }

  void _backspace(String text) {
    //delete one character
    String exp = '';
    String sExp = '';
    if (_resultType == ResultType.dontHave) {
      if (_showExpression.isNotEmpty) {
        // if use _expression.isNotEmpty may be get error
        // beacuse in add number if 000..00 in first
        // this add to _expression but just add one 0 to _showExpression
        exp = _expression.substring(0, _expression.length - 1);

        if (_operatorIndex.isNotEmpty &&
            _showExpression.length == _operatorIndex.last) {
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
          sExp = n;
        } else {
          n = _showExpression.substring(
              _operatorIndex.last, _showExpression.length - 1);
          if (!n.contains('.')) {
            //if not a float part reset commas of number
            n = _addComma(n.replaceAll(',', ''));
          }
          sExp = _showExpression.substring(0, _operatorIndex.last) + n;
        }
      }
    } else if (_resultType == ResultType.correct) {
      //if have result expression = result
      exp = _result;
      sExp = _result;
      _resultType = ResultType.dontHave;
      _getExpressionColor();
    } else {
      exp = '';
      sExp = '';
      _resultType = ResultType.dontHave;
      _getExpressionColor();
    }
    _expression = exp;
    setState(() {
      _showExpression = sExp;
      _result = '';
    });
  }

  void _clear(String text) {
    _haveDot = false;
    _resultType = ResultType.dontHave;
    _expression = '';
    _operatorIndex = [];
    setState(() {
      _showExpression = '';
      _result = '';
    });
    _getExpressionColor();
  }

  void _getExpressionColor() {
    Color c;
    if (_resultType == ResultType.dontHave) {
      c = kExpressionColor;
    } else {
      c = kExpressionColorAfterResult;
    }
    setState(() {
      _expressionColor = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        centerTitle: true,
        title: const Text(
          'Calculator',
          textDirection: TextDirection.ltr,
          style: TextStyle(fontStyle: FontStyle.normal),
        ),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Text(
              _showExpression,
              textDirection: TextDirection.ltr,
              style: kExpressionTextStyle.copyWith(
                color: _expressionColor,
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Text(
              _result,
              textDirection: TextDirection.ltr,
              style: kResultTextStyle,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CalculatorButton(
              text: 'C',
              backgroundColor: kOperatorButtonColor,
              textColor: Colors.black,
              callback: _clear,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
            CalculatorButton(
              text: kDivSymbol,
              backgroundColor: kOperatorButtonColor,
              textColor: Colors.black,
              callback: _onOperatorClick,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
            CalculatorButton(
              text: kMulSymbol,
              backgroundColor: kOperatorButtonColor,
              textColor: Colors.black,
              callback: _onOperatorClick,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
            CalculatorButton(
              text: kBackSymbol,
              callback: _backspace,
              backgroundColor: kOperatorButtonColor,
              textColor: Colors.black,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
          ],
        ),
        Row(
          children: [
            CalculatorButton(
              text: '7',
              backgroundColor: Colors.white,
              textColor: Colors.black,
              callback: _onNumClick,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
            CalculatorButton(
              text: '8',
              backgroundColor: Colors.white,
              textColor: Colors.black,
              callback: _onNumClick,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
            CalculatorButton(
              text: '9',
              backgroundColor: Colors.white,
              textColor: Colors.black,
              callback: _onNumClick,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
            CalculatorButton(
              text: kMinusSymbol,
              backgroundColor: kOperatorButtonColor,
              textColor: Colors.black,
              callback: _onOperatorClick,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
          ],
        ),
        Row(
          children: [
            CalculatorButton(
              text: '4',
              backgroundColor: Colors.white,
              textColor: Colors.black,
              callback: _onNumClick,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
            CalculatorButton(
              text: '5',
              backgroundColor: Colors.white,
              textColor: Colors.black,
              callback: _onNumClick,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
            CalculatorButton(
              text: '6',
              backgroundColor: Colors.white,
              textColor: Colors.black,
              callback: _onNumClick,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
            CalculatorButton(
              text: kAddSymbol,
              backgroundColor: kOperatorButtonColor,
              textColor: Colors.black,
              callback: _onOperatorClick,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
          ],
        ),
        Row(
          children: [
            CalculatorButton(
              text: '1',
              backgroundColor: Colors.white,
              textColor: Colors.black,
              callback: _onNumClick,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
            CalculatorButton(
              text: '2',
              backgroundColor: Colors.white,
              textColor: Colors.black,
              callback: _onNumClick,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
            CalculatorButton(
              text: '3',
              backgroundColor: Colors.white,
              textColor: Colors.black,
              callback: _onNumClick,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
            CalculatorButton(
              text: '.',
              backgroundColor: Colors.white,
              textColor: Colors.black,
              callback: _onNumClick,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
          ],
        ),
        Row(
          children: [
            CalculatorButton(
              text: '0',
              backgroundColor: Colors.white,
              textColor: Colors.black,
              callback: _onNumClick,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
            CalculatorButton(
              text: '(',
              backgroundColor: kOperatorButtonColor,
              textColor: Colors.black,
              callback: _onOperatorClick,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
            CalculatorButton(
              text: ')',
              backgroundColor: kOperatorButtonColor,
              textColor: Colors.black,
              callback: _onOperatorClick,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
            CalculatorButton(
              text: '=',
              callback: _evaluate,
              backgroundColor: Colors.green,
              textColor: Colors.black,
              height: size.height * 0.1,
              width: size.width * 0.25,
            ),
          ],
        ),
      ]),
    );
  }
}
