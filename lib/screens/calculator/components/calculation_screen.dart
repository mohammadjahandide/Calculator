import 'package:calculator/providers/calculation_provider.dart';
import 'package:calculator/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculationScreen extends StatelessWidget {
  final Color? expressionColor;
  final Color? reslutColor;

  const CalculationScreen({
    Key? key,
    this.expressionColor,
    this.reslutColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CalculationProvider>(context);
    return Column(
      children: [
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Text(
              provider.getExpression,
              textDirection: TextDirection.ltr,
              style: kExpressionTextStyle.copyWith(
                color: provider.getExpressionColor,
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Text(
              provider.getResult,
              textDirection: TextDirection.ltr,
              style: kResultTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}
