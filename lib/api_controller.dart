import 'dart:math';

import 'package:flutter/material.dart';

import 'models/config_json_model.dart';

class CalculatorController {
  String _defaultRateOfInterest = "1";
  String _defaultNoOfTimeCoumoundInYear = "1";
  String _defaultNoOfYear = "1";

  ///geters
  String get defaultRateOfInterest => _defaultRateOfInterest;
  String get defaultNoOfTimeCoumoundInYear => _defaultNoOfTimeCoumoundInYear;
  String get defaultNoOfYear => _defaultNoOfYear;

  ///seters
  String setDefaultRateOfInterest(value) => _defaultRateOfInterest = value;
  String setDefaultNoOfTimeCoumoundInYear(value) =>
      _defaultNoOfTimeCoumoundInYear = value;
  String setDefaultNoOfYear(value) => _defaultNoOfYear = value;

  ///load json data from assets folder
  Future<CalcData> loadJsonData(BuildContext context) async {
    String jsonString =
        await DefaultAssetBundle.of(context).loadString('assets/config.json');
    return dataFromJson(jsonString);
  }

  ///calculate function
  double calculateCompoundInterest({
    required int principalAmount,
    required double rateOfInterest,
    required int numberOfTimesToCompound,
    required int numberOfYears,
  }) {
    double amount = principalAmount.toDouble() *
        pow((1 + (rateOfInterest / (100 * numberOfTimesToCompound))),
            (numberOfTimesToCompound * numberOfYears));
    double compoundInterest = amount - principalAmount;
    return compoundInterest;
  }

  ///show result function
  void showResult(
      {required BuildContext context,
      required double result,
      required String resultMode,
      required int textColor,
      required double textSize}) {
    if (resultMode == "dialog") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Result",
            style: TextStyle(color: Color(textColor), fontSize: textSize),
          ),
          content: Text("Total compound intrest is $result"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Okay"),
            )
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result.toString())));
    }
  }
}
