import 'package:dio/dio.dart';
import 'package:employee_timesheet/data/services/api_service.dart';

class GraphDetailsRepository {
  final ApiService apiService = ApiService();

  Future<Response?> getGraphDetails(
      Map<String, String> jsonData, DateTime pickedDate) async {
    return apiService.post("http://192.168.0.181:80/mycompany/public/api/graph",
        jsonData: jsonData);
  }

  Future<Response?> addProjectTasks(Map<String, dynamic> jsonData) {
    return apiService.post(
        "http://192.168.0.181:80/mycompany/public/api/working_log",
        jsonData: jsonData);
  }
}
