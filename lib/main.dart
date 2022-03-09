import 'package:calculator/providers/calculation_provider.dart';
import 'package:calculator/screens/calculator/calculator_screen.dart';
import 'package:calculator/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const StartScreen());
}

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalculationProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CalculatorScreen(),
      ),
    );
  }
}
