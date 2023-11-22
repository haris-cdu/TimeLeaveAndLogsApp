import 'dart:convert';

import 'package:employee_timesheet/data/repositories/graphdetails_repository.dart';
import 'package:employee_timesheet/model/graph_data_model.dart';
import 'package:flutter/material.dart';

import '../constants/functions.dart';
import '../model/add_project_model.dart';

class GraphDataProvider extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  List<Graph> graph = [];
  List<WorkingLog> workingLog = [];
  List<LeaveLog> leaveLog = [];
  bool isLoading = false;

  void goPrevious7Days() {
    selectedDate = selectedDate.subtract(const Duration(days: 7));
    notifyListeners();
  }

  void goNext7Days() {
    if (selectedDate
        .isBefore(DateTime.now().subtract(const Duration(days: 7)))) {
      selectedDate = selectedDate.add(const Duration(days: 7));
      getGraphDetails();
    }
    notifyListeners();
  }

  void selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now());

    if (pickedDate != null && pickedDate != selectedDate) {
      selectedDate = pickedDate;
      getGraphDetails();
    }
    notifyListeners();
  }

  void getGraphDetails() async {
    await GraphDetailsRepository().getGraphDetails(
        {"started_date": formatJSONDate(selectedDate)},
        selectedDate).then((response) {
      if (response != null && response.statusCode == 200) {
        Welcome welcome = Welcome.fromJson(response.data);
        graph = welcome.data.graph;
        workingLog = welcome.data.workingLog;
        leaveLog = welcome.data.leaveLog;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  Future<int> addProjectAndTasks(List<Project> projects) async {
    List<Map<String, dynamic>> jsonListOfProjects = [];
    for (int i = 0; i < projects.length; i++) {
      jsonListOfProjects.add(projects[i].toJson());
    }

    final requestData = {
      "date": formatJSONDate(selectedDate),
      "projects": json.encode(jsonListOfProjects),
    };

    try {
      final response =
          await GraphDetailsRepository().addProjectTasks(requestData);

      if (response != null && response.statusCode == 200) {
        return response.data['code'];
      }
      return -1;
    } catch (error) {
      print("Error: $error");
      return -1;
    }
  }

  Future<int> addLeaveLogs(String leaveType, String reason) async {
    int leaveCode = 1;
    if (leaveType == "Half day") {
      leaveCode = 2;
    } else if (leaveType == "Early going") {
      leaveCode = 3;
    } else {
      leaveCode = 4;
    }
    final requestData = {
      "date": formatJSONDate(selectedDate),
      "leave_type": leaveCode,
      "reason": reason.isEmpty ? "Did not work!" : reason
    };
    try {
      final response = await GraphDetailsRepository().addLeaveLog(requestData);

      if (response != null && response.statusCode == 200) {
        return response.data['code'];
      }
      return -1;
    } catch (error) {
      print("Error: $error");
      return -1;
    }
  }

  Future<int> updateLeave(int leaveId, String leaveType, String reason) async {
    int leaveCode = 1;
    if (leaveType == "Full day") {
      leaveCode = 1;
    } else if (leaveType == "Half day") {
      leaveCode = 2;
    } else if (leaveType == "Early going") {
      leaveCode = 3;
    } else {
      leaveCode = 4;
    }
    final requestData = {
      "date": formatJSONDate(selectedDate),
      "leave_id": leaveId,
      "leave_type": leaveCode,
      "reason": reason.isEmpty ? "Not worked" : reason
    };
    try {
      final response =
          await GraphDetailsRepository().updateLeaveLog(requestData);

      if (response != null && response.statusCode == 200) {
        return response.data['code'];
      }
      return -1;
    } catch (error) {
      print("Error: $error");
      return -1;
    }
  }

  Future<int> deleteLeave(int leaveId) async {
    final requestData = {"leave_id": leaveId};
    try {
      final response =
          await GraphDetailsRepository().deleteLeaveLog(requestData);

      if (response != null && response.statusCode == 200) {
        return response.data['code'];
      }
      return -1;
    } catch (error) {
      print("Error: $error");
      return -1;
    }
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}

//2 - sick leave 4 hours
//3 - 2 hours sick leave
//4 - sick leave 2 hours
