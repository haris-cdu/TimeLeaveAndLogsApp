import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/graph_data_model.dart';

String formatDatePicker(DateTime dateTime) {
  DateFormat formatter = DateFormat('dd MMM yyyy');
  return formatter.format(dateTime);
}

String formatJSONDate(DateTime dateTime) {
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(dateTime);
}

int getDateFromDateTime(String dateTime) {
  DateTime date = DateTime.parse(dateTime);
  return date.day;
}

double convertFromTime(String timeString) {
  List<String> timeParts = timeString.split(':');
  int hours = int.parse(timeParts[0]);
  int minutes = int.parse(timeParts[1]);
  double afterDecimal = minutes / 60.0;
  return hours + afterDecimal;
}

List<BarChartRodData> getBarChartRodData(Graph graph) {
  if (graph.type == "company_off") {
    return [BarChartRodData(toY: 8, fromY: 0, width: 15, color: Colors.red)];
  } else if (graph.type == "working") {
    return [
      BarChartRodData(
          toY: convertFromTime(graph.log.workingHours),
          fromY: 0,
          width: 15,
          color: Colors.green)
    ];
  } else if (graph.type == "causal") {
    return [
      BarChartRodData(
          toY: convertFromTime(graph.log.leaveHours),
          fromY: 0,
          width: 15,
          color: Colors.orange)
    ];
  } else {
    return [
      BarChartRodData(
          toY: convertFromTime(graph.log.workingHours),
          fromY: 0,
          width: 15,
          color: Colors.green),
      BarChartRodData(
          toY: convertFromTime(graph.log.leaveHours) +
              convertFromTime(graph.log.workingHours),
          fromY: convertFromTime(graph.log.workingHours),
          width: 15,
          color: Colors.red),
    ];
  }
}
