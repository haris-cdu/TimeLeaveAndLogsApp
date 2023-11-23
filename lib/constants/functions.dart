import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/graph_data_model.dart';

String formatDatePicker(DateTime dateTime) {
  DateFormat formatter = DateFormat('dd MMM yyyy');
  return formatter.format(dateTime);
}

String formatWorkLogDate(DateTime dateTime) {
  DateFormat formatter = DateFormat('EEEE - dd MMM,yyyy');
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

int convertFromTime(String timeString) {
  List<String> timeParts = timeString.split(':');
  int hours = int.parse(timeParts[0]);
  return hours;
}

List<BarChartRodData> getBarChartRodData(Graph graph) {
  if (graph.type == "company_off") {
    return [BarChartRodData(toY: 8, fromY: 0, width: 15, color: Colors.red)];
  } else if (graph.type == "working") {
    return [
      BarChartRodData(
          toY: double.parse(convertFromTime(graph.log.workingHours).toString()),
          fromY: 0,
          width: 15,
          color: Colors.green)
    ];
  } else if (graph.type == "causal") {
    return [
      BarChartRodData(
          toY: double.parse(convertFromTime(graph.log.leaveHours).toString()),
          fromY: 0,
          width: 15,
          color: Colors.orange)
    ];
  } else {
    return [
      BarChartRodData(
          toY: double.parse(convertFromTime(graph.log.workingHours).toString()),
          fromY: 0,
          width: 15,
          color: Colors.green),
      BarChartRodData(
          toY: double.parse(convertFromTime(graph.log.leaveHours).toString()) +
              double.parse(convertFromTime(graph.log.workingHours).toString()),
          fromY:
              double.parse(convertFromTime(graph.log.workingHours).toString()),
          width: 15,
          color: Colors.red),
    ];
  }
}

dynamic checkIfLeaveAdded(DateTime dateTime, List<LeaveLog> leaveList) {
  for (int i = 0; i < leaveList.length; i++) {
    if (formatJSONDate(dateTime) == formatJSONDate(leaveList[i].date)) {
      return leaveList[i];
    }
  }
  return null;
}

dynamic checkIfWorkingLogAdded(
    DateTime dateTime, List<WorkingLog> workingList) {
  for (int i = 0; i < workingList.length; i++) {
    if (formatJSONDate(dateTime) == formatJSONDate(workingList[i].date)) {
      return workingList[i];
    }
  }
  return null;
}
