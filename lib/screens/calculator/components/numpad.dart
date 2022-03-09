import 'package:calculator/providers/calculation_provider.dart';
import 'package:calculator/utils/constants.dart';
import 'package:calculator/screens/components/calculator_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Numpad extends StatelessWidget {
  const Numpad({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CalculationProvider provider =
        Provider.of<CalculationProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    double buttonHeight = size.height * 0.1;
    double buttonWidth = size.width * 0.25;
    return Container(
      color: kBackgroundColor,
      width: size.width,
      height: size.height * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CalculatorButton(
                text: 'C',
                backgroundColor: kOperatorButtonColor,
                textColor: Colors.black,
                callback: provider.clear,
                height: buttonHeight,
                width: buttonWidth,
              ),
              CalculatorButton(
                text: kDivSymbol,
                backgroundColor: kOperatorButtonColor,
                textColor: Colors.black,
                callback: provider.onOperatorClick,
                height: buttonHeight,
                width: buttonWidth,
              ),
              CalculatorButton(
                text: kMulSymbol,
                backgroundColor: kOperatorButtonColor,
                textColor: Colors.black,
                callback: provider.onOperatorClick,
                height: buttonHeight,
                width: buttonWidth,
              ),
              CalculatorButton(
                text: kBackSymbol,
                callback: provider.backspace,
                backgroundColor: kOperatorButtonColor,
                textColor: Colors.black,
                height: buttonHeight,
                width: buttonWidth,
              ),
            ],
          ),
          Row(
            children: [
              CalculatorButton(
                text: '7',
                backgroundColor: Colors.white,
                textColor: Colors.black,
                callback: provider.onNumClick,
                height: buttonHeight,
                width: buttonWidth,
              ),
              CalculatorButton(
                text: '8',
                backgroundColor: Colors.white,
                textColor: Colors.black,
                callback: provider.onNumClick,
                height: buttonHeight,
                width: buttonWidth,
              ),
              CalculatorButton(
                text: '9',
                backgroundColor: Colors.white,
                textColor: Colors.black,
                callback: provider.onNumClick,
                height: buttonHeight,
                width: buttonWidth,
              ),
              CalculatorButton(
                text: kMinusSymbol,
                backgroundColor: kOperatorButtonColor,
                textColor: Colors.black,
                callback: provider.onOperatorClick,
                height: buttonHeight,
                width: buttonWidth,
              ),
            ],
          ),
          Row(
            children: [
              CalculatorButton(
                text: '4',
                backgroundColor: Colors.white,
                textColor: Colors.black,
                callback: provider.onNumClick,
                height: buttonHeight,
                width: buttonWidth,
              ),
              CalculatorButton(
                text: '5',
                backgroundColor: Colors.white,
                textColor: Colors.black,
                callback: provider.onNumClick,
                height: buttonHeight,
                width: buttonWidth,
              ),
              CalculatorButton(
                text: '6',
                backgroundColor: Colors.white,
                textColor: Colors.black,
                callback: provider.onNumClick,
                height: buttonHeight,
                width: buttonWidth,
              ),
              CalculatorButton(
                text: kAddSymbol,
                backgroundColor: kOperatorButtonColor,
                textColor: Colors.black,
                callback: provider.onOperatorClick,
                height: buttonHeight,
                width: buttonWidth,
              ),
            ],
          ),
          Row(
            children: [
              CalculatorButton(
                text: '1',
                backgroundColor: Colors.white,
                textColor: Colors.black,
                callback: provider.onNumClick,
                height: buttonHeight,
                width: buttonWidth,
              ),
              CalculatorButton(
                text: '2',
                backgroundColor: Colors.white,
                textColor: Colors.black,
                callback: provider.onNumClick,
                height: buttonHeight,
                width: buttonWidth,
              ),
              CalculatorButton(
                text: '3',
                backgroundColor: Colors.white,
                textColor: Colors.black,
                callback: provider.onNumClick,
                height: buttonHeight,
                width: buttonWidth,
              ),
              CalculatorButton(
                text: '.',
                backgroundColor: Colors.white,
                textColor: Colors.black,
                callback: provider.onNumClick,
                height: buttonHeight,
                width: buttonWidth,
              ),
            ],
          ),
          Row(
            children: [
              CalculatorButton(
                text: '0',
                backgroundColor: Colors.white,
                textColor: Colors.black,
                callback: provider.onNumClick,
                height: buttonHeight,
                width: buttonWidth,
              ),
              CalculatorButton(
                text: '(',
                backgroundColor: kOperatorButtonColor,
                textColor: Colors.black,
                callback: provider.onOperatorClick,
                height: buttonHeight,
                width: buttonWidth,
              ),
              CalculatorButton(
                text: ')',
                backgroundColor: kOperatorButtonColor,
                textColor: Colors.black,
                callback: provider.onOperatorClick,
                height: buttonHeight,
                width: buttonWidth,
              ),
              CalculatorButton(
                text: '=',
                callback: provider.evaluate,
                backgroundColor: Colors.green,
                textColor: Colors.black,
                height: buttonHeight,
                width: buttonWidth,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
