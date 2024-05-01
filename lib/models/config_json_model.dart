// To parse this JSON data, do
//
//     final data = dataFromJson(jsonString);

import 'dart:convert';

CalcData dataFromJson(String str) => CalcData.fromJson(json.decode(str));

String dataToJson(CalcData data) => json.encode(data.toJson());

class CalcData {
  NoOfYears rateOfInterest;
  PrincipalAmt principalAmt;
  NoOfYears timesToCompoundYear;
  NoOfYears noOfYears;
  NoOfYears output;

  CalcData({
    required this.rateOfInterest,
    required this.principalAmt,
    required this.timesToCompoundYear,
    required this.noOfYears,
    required this.output,
  });

  factory CalcData.fromJson(Map<String, dynamic> json) => CalcData(
        rateOfInterest: NoOfYears.fromJson(json["rate_of_interest"]),
        principalAmt: PrincipalAmt.fromJson(json["principal_amt"]),
        timesToCompoundYear: NoOfYears.fromJson(json["times_to_compound_year"]),
        noOfYears: NoOfYears.fromJson(json["no_of_years"]),
        output: NoOfYears.fromJson(json["output"]),
      );

  Map<String, dynamic> toJson() => {
        "rate_of_interest": rateOfInterest.toJson(),
        "principal_amt": principalAmt.toJson(),
        "times_to_compound_year": timesToCompoundYear.toJson(),
        "no_of_years": noOfYears.toJson(),
        "output": output.toJson(),
      };
}

class NoOfYears {
  String textColor;
  int textSize;
  String labelText;
  List<Option>? options;
  String? mode;

  NoOfYears({
    required this.textColor,
    required this.textSize,
    required this.labelText,
    this.options,
    this.mode,
  });

  factory NoOfYears.fromJson(Map<String, dynamic> json) => NoOfYears(
        textColor: json["text_color"],
        textSize: json["text_size"],
        labelText: json["label_text"],
        options: json["options"] == null
            ? []
            : List<Option>.from(
                json["options"]!.map((x) => Option.fromJson(x))),
        mode: json["mode"],
      );

  Map<String, dynamic> toJson() => {
        "text_color": textColor,
        "text_size": textSize,
        "label_text": labelText,
        "options": options == null
            ? []
            : List<dynamic>.from(options!.map((x) => x.toJson())),
        "mode": mode,
      };
}

class Option {
  String label;
  String value;

  Option({
    required this.label,
    required this.value,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        label: json["label"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
      };
}

class PrincipalAmt {
  String hintText;
  String textColor;
  int textSize;
  MinAmt minAmt;
  int maxAmt;
  String maxErrMsg;

  PrincipalAmt({
    required this.hintText,
    required this.textColor,
    required this.textSize,
    required this.minAmt,
    required this.maxAmt,
    required this.maxErrMsg,
  });

  factory PrincipalAmt.fromJson(Map<String, dynamic> json) => PrincipalAmt(
        hintText: json["hint_text"],
        textColor: json["text_color"],
        textSize: json["text_size"],
        minAmt: MinAmt.fromJson(json["min_amt"]),
        maxAmt: json["max_amt"],
        maxErrMsg: json["max_err_msg"],
      );

  Map<String, dynamic> toJson() => {
        "hint_text": hintText,
        "text_color": textColor,
        "text_size": textSize,
        "min_amt": minAmt.toJson(),
        "max_amt": maxAmt,
        "max_err_msg": maxErrMsg,
      };
}

class MinAmt {
  int upto3;
  int upto7;
  int upto12;
  int other;
  String minErrMsg;

  MinAmt({
    required this.upto3,
    required this.upto7,
    required this.upto12,
    required this.other,
    required this.minErrMsg,
  });

  factory MinAmt.fromJson(Map<String, dynamic> json) => MinAmt(
        upto3: json["upto_3"],
        upto7: json["upto_7"],
        upto12: json["upto_12"],
        other: json["other"],
        minErrMsg: json["min_err_msg"],
      );

  Map<String, dynamic> toJson() => {
        "upto_3": upto3,
        "upto_7": upto7,
        "upto_12": upto12,
        "other": other,
        "min_err_msg": minErrMsg,
      };
}
