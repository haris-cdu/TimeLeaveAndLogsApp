import 'dart:convert';

import 'package:employee_timesheet/data/repositories/graphdetails_repository.dart';
import 'package:employee_timesheet/model/graph_data_model.dart';
import 'package:flutter/material.dart';

import '../constants/functions.dart';
import '../model/add_project_model.dart';

class GraphDataProvider extends ChangeNotifier {
  List<Graph> graph = [];
  List<WorkingLog> workingLog = [];
  List<LeaveLog> leaveLog = [];
  bool isLoading = false;

  void getGraphDetails(pickedDate) async {
    await GraphDetailsRepository().getGraphDetails(
        {"started_date": formatJSONDate(pickedDate)},
        pickedDate).then((response) {
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
      // "date": formatJSONDate(DateTime.now()),
      "date": "2002-12-12",
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

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
