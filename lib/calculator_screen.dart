import 'package:flutter/material.dart';
import 'package:interest_calculator/api_controller.dart';

import 'models/config_json_model.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  ///
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// textediting controller
  final TextEditingController pamtController = TextEditingController();
  final TextEditingController resultController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    pamtController.dispose();
    resultController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // initialize controller
    CalculatorController controller = CalculatorController();

    void onFormSubmit(
        {required String resultMode,
        required int textColor,
        required double textSize}) {
      if (formKey.currentState!.validate()) {
        var result = controller.calculateCompoundInterest(
          principalAmount: int.parse(pamtController.text),
          rateOfInterest: double.parse(controller.defaultRateOfInterest),
          numberOfTimesToCompound:
              int.parse(controller.defaultNoOfTimeCoumoundInYear),
          numberOfYears: int.parse(controller.defaultNoOfYear),
        );
        resultController.text = result.toString();

        controller.showResult(
          context: context,
          result: result,
          resultMode: resultMode,
          textColor: textColor,
          textSize: textSize,
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Compound interest calculator",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<CalcData>(
        future: controller.loadJsonData(context),
        builder: (BuildContext context, AsyncSnapshot<CalcData> snapshot) {
          ///
          final rateOfInterest = snapshot.data?.rateOfInterest;
          final timeToCompoundInYear = snapshot.data?.timesToCompoundYear;
          final noOfYear = snapshot.data?.noOfYears;
          final principalAmt = snapshot.data?.principalAmt;
          final resultMode = snapshot.data;

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButtonFormField<String>(
                      value: controller.defaultRateOfInterest,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: rateOfInterest?.options
                          ?.map((items) => DropdownMenuItem<String>(
                                value: items.value,
                                child: Text(
                                  items.label.toString(),
                                  style: TextStyle(
                                      color: Color(
                                          int.parse(rateOfInterest.textColor)),
                                      fontSize: double.parse(
                                          rateOfInterest.textSize.toString())),
                                ),
                              ))
                          .toList(),
                      onChanged: (String? newValue) =>
                          controller.setDefaultRateOfInterest(newValue),
                      decoration: InputDecoration(
                        labelText: rateOfInterest?.labelText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    style: TextStyle(
                        color: Color(
                            int.parse(principalAmt?.textColor ?? "0xffFF0000")),
                        fontSize: double.parse(
                            principalAmt?.textSize.toString() ?? "15")),
                    decoration: InputDecoration(
                        labelText: principalAmt?.hintText ?? 'Principle Amount',
                        errorMaxLines: 5),
                    keyboardType: TextInputType.number,
                    controller: pamtController,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Principal Amount can not be empty";
                      } else if (["1", "2", "3"]
                          .contains(controller.defaultRateOfInterest)) {
                        if (int.parse(pamtController.text) < 10000) {
                          return principalAmt?.minAmt.minErrMsg;
                        }
                      } else if (["4", "5", "6", "7"]
                          .contains(controller.defaultRateOfInterest)) {
                        if (int.parse(pamtController.text) < 50000) {
                          return principalAmt?.minAmt.minErrMsg;
                        }
                      } else if (["8", "9", "10", "11", "12"]
                          .contains(controller.defaultRateOfInterest)) {
                        if (int.parse(pamtController.text) < 750000) {
                          return principalAmt?.minAmt.minErrMsg;
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButtonFormField<String>(
                      value: controller.defaultNoOfTimeCoumoundInYear,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: timeToCompoundInYear?.options
                          ?.map((items) => DropdownMenuItem<String>(
                                value: items.value,
                                child: Text(
                                  items.label.toString(),
                                  style: TextStyle(
                                      color: Color(int.parse(
                                          timeToCompoundInYear.textColor)),
                                      fontSize: double.parse(
                                          timeToCompoundInYear.textSize
                                              .toString())),
                                ),
                              ))
                          .toList(),
                      onChanged: (String? newValue) =>
                          controller.setDefaultNoOfTimeCoumoundInYear(newValue),
                      decoration: InputDecoration(
                        labelText: timeToCompoundInYear?.labelText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButtonFormField<String>(
                      value: controller.defaultNoOfYear,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: noOfYear?.options
                          ?.map((items) => DropdownMenuItem<String>(
                                value: items.label,
                                child: Text(
                                  items.value.toString(),
                                  style: TextStyle(
                                      color:
                                          Color(int.parse(noOfYear.textColor)),
                                      fontSize: double.parse(
                                          noOfYear.textSize.toString())),
                                ),
                              ))
                          .toList(),
                      onChanged: (String? newValue) =>
                          controller.setDefaultNoOfYear(newValue),
                      decoration: InputDecoration(
                        labelText: noOfYear?.labelText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => onFormSubmit(
                        resultMode: resultMode?.output.mode ?? 'dialog',
                        textColor: int.parse(
                            resultMode?.output.textColor.toString() ??
                                "0xff000000"),
                        textSize: double.parse(
                            resultMode?.output.textSize.toString() ?? "15.0")),
                    child: const Text("Calculate Compound Interest"),
                  ),
                  const SizedBox(height: 15),
                  // ignore: unrelated_type_equality_checks
                  if (resultMode == "textfield")
                    TextFormField(
                      decoration: const InputDecoration(hintText: "Result..."),
                      controller: resultController,
                      enabled: false,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
