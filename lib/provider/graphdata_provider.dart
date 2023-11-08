import 'package:employee_timesheet/data/repositories/graphdetails_repository.dart';
import 'package:employee_timesheet/model/graph_data_model.dart';
import 'package:flutter/material.dart';

import '../constants/functions.dart';

class GraphDataProvider extends ChangeNotifier {
  List<Graph> data = [];

  void getGraphDetails(pickedDate) async {
    await GraphDetailsRepository().getGraphDetails(
        {"started_date": formatJSONDate(pickedDate)},
        pickedDate).then((response) {
      if (response != null && response.statusCode == 200) {
        Welcome welcome = Welcome.fromJson(response.data);
        data = welcome.data.graph;
        notifyListeners();
      }
    });
    notifyListeners();
  }
}
