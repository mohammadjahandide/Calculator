import 'package:calculator/database/database_handler.dart';
import 'package:calculator/model/history.dart';
import 'package:calculator/screens/calculator/components/calculation_screen.dart';
import 'package:calculator/screens/calculator/components/history_dialog.dart';
import 'package:calculator/screens/calculator/components/numpad.dart';
import 'package:calculator/utils/constants.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  Future<void> _openHistory(BuildContext context) async {
    DataBaseHandler dataBaseHandler = DataBaseHandler();
    List<History> histories = await dataBaseHandler.getHistory();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return HistoryDialog(
            histories: histories,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        // centerTitle: true,
        title: const Text(
          'Calculator',
          textDirection: TextDirection.ltr,
          style: TextStyle(fontStyle: FontStyle.normal),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () async {
              await _openHistory(context);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          CalculationScreen(),
          Numpad(),
        ],
      ),
    );
  }
}
