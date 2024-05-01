import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'models/config_json_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interest Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String defaultRateOfInterest = "1";
  String defaultNoOfTimeCoumoundInYear = "1";
  String defaultNoOfYear = "1";
  TextEditingController pamtController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Future<CalcData> loadJsonData() async {
    String jsonString =
        await DefaultAssetBundle.of(context).loadString('assets/config.json');
    return dataFromJson(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Compound interest calculator",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: FutureBuilder(
            future: loadJsonData(),
            builder: (BuildContext context, AsyncSnapshot<CalcData> snapshot) {
              final rateOfInterest = snapshot.data?.rateOfInterest;
              final timeToCompoundInYear = snapshot.data?.timesToCompoundYear;
              final noOfYear = snapshot.data?.noOfYears;
              final principalAmt = snapshot.data?.principalAmt;
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              return Form(
                key: formKey,
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(children: [
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField(
                        value: defaultRateOfInterest,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: rateOfInterest?.options?.map((items) {
                          return DropdownMenuItem(
                            value: items.value,
                            child: Text(items.label.toString()),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            defaultRateOfInterest = newValue ?? '1';
                          });
                        },
                        decoration: InputDecoration(
                          labelText: rateOfInterest?.labelText,
                        ),
                      ),
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: principalAmt!.hintText),
                      keyboardType: TextInputType.number,
                      controller: pamtController,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return displayError(
                              context, "Principal Amount can not be empty");
                        } else if (defaultRateOfInterest.contains("1") ||
                            defaultRateOfInterest.contains("2") ||
                            defaultRateOfInterest.contains("3")) {
                          if (int.parse(pamtController.text) > 1000) {
                            displayError(
                                context, principalAmt.minAmt.minErrMsg);
                          }
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField(
                        value: defaultNoOfTimeCoumoundInYear,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: timeToCompoundInYear?.options?.map((items) {
                          return DropdownMenuItem(
                            value: items.value,
                            child: Text(items.label.toString()),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            defaultNoOfTimeCoumoundInYear = newValue ?? '2';
                          });
                        },
                        decoration: InputDecoration(
                          labelText: timeToCompoundInYear?.labelText,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField(
                        value: defaultNoOfYear,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: noOfYear?.options?.map((items) {
                          return DropdownMenuItem(
                            value: items.label,
                            child: Text(items.value.toString()),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            defaultNoOfYear = newValue ?? '2';
                          });
                        },
                        decoration: InputDecoration(
                          labelText: noOfYear?.labelText,
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            calculateCompoundInterest(
                              key: formKey,
                              principalAmount: int.parse(pamtController.text),
                              rateOfInterest:
                                  double.parse(defaultRateOfInterest),
                              numberOfTimesToCompound:
                                  int.parse(defaultNoOfTimeCoumoundInYear),
                              numberOfYears: int.parse(defaultNoOfYear),
                            );
                          }
                        },
                        child: const Text("Calculate Compound Interese"))
                  ]),
                ),
              );
            }));
  }
}

double calculateCompoundInterest({
  required int principalAmount,
  required double rateOfInterest,
  required int numberOfTimesToCompound,
  required int numberOfYears,
  required GlobalKey key,
}) {
  // print(rateOfInterest);
  // print(principalAmount);
  // print(numberOfTimesToCompound);
  // print(numberOfYears);
  // Calculate compound interes
  double amount = principalAmount *
      (1 + (rateOfInterest / (100 * numberOfTimesToCompound))) *
      pow((1 + (rateOfInterest / (100 * numberOfTimesToCompound))),
          (numberOfTimesToCompound * numberOfYears));
  double compoundInterest = amount - principalAmount;
  print("Compound Interest is : $compoundInterest");
  return compoundInterest;
}

displayError(BuildContext context, String err) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(err)));
}
