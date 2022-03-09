import 'package:calculator/model/history.dart';
import 'package:calculator/providers/calculation_provider.dart';
import 'package:calculator/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryDialog extends StatelessWidget {
  final List<History> histories;

  const HistoryDialog({
    Key? key,
    required this.histories,
  }) : super(key: key);

  Widget _listViewItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Provider.of<CalculationProvider>(context, listen: false)
            .setExpression(histories[index].result);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.only(
          right: 5,
          left: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              histories[index].expression + '=',
              style: kExpressionTextStyle.copyWith(
                color: Colors.orangeAccent,
                fontSize: 16,
              ),
            ),
            Text(
              histories[index].result,
              textDirection: TextDirection.ltr,
              style: kResultTextStyle.copyWith(
                fontSize: 16,
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: kBackgroundColor,
      child: Scaffold(
        body: ListView.builder(
          itemBuilder: (context, index) => _listViewItem(context, index),
          itemCount: histories.length,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Provider.of<CalculationProvider>(context, listen: false)
                .deleteHistory();
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.delete,
          ),
        ),
      ),
    );
  }
}
