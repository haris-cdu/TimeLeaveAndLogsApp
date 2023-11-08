class Welcome {
  int code;
  String message;
  Data data;

  Welcome({
    required this.code,
    required this.message,
    required this.data,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  List<Graph> graph;
  List<dynamic> workingLog;
  List<LeaveLog> leaveLog;

  Data({
    required this.graph,
    required this.workingLog,
    required this.leaveLog,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        graph: List<Graph>.from(json["graph"].map((x) => Graph.fromJson(x))),
        workingLog: List<dynamic>.from(json["working_log"].map((x) => x)),
        leaveLog: List<LeaveLog>.from(
            json["leave_log"].map((x) => LeaveLog.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "graph": List<dynamic>.from(graph.map((x) => x.toJson())),
        "working_log": List<dynamic>.from(workingLog.map((x) => x)),
        "leave_log": List<dynamic>.from(leaveLog.map((x) => x.toJson())),
      };
}

class Graph {
  DateTime date;
  String day;
  Log log;
  String type;

  Graph({
    required this.date,
    required this.day,
    required this.log,
    required this.type,
  });

  factory Graph.fromJson(Map<String, dynamic> json) => Graph(
        date: DateTime.parse(json["date"]),
        day: json["day"],
        log: Log.fromJson(json["log"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "day": day,
        "log": log.toJson(),
        "type": type,
      };
}

class Log {
  String workingHours;
  String leaveHours;

  Log({
    required this.workingHours,
    required this.leaveHours,
  });

  factory Log.fromJson(Map<String, dynamic> json) => Log(
        workingHours: json["working_hours"],
        leaveHours: json["leave_hours"],
      );

  Map<String, dynamic> toJson() => {
        "working_hours": workingHours,
        "leave_hours": leaveHours,
      };
}

class LeaveLog {
  int id;
  DateTime date;
  String day;
  DateTime submitTime;
  DateTime updateTime;
  String reason;
  String totalTime;
  int empId;
  String type;

  LeaveLog({
    required this.id,
    required this.date,
    required this.day,
    required this.submitTime,
    required this.updateTime,
    required this.reason,
    required this.totalTime,
    required this.empId,
    required this.type,
  });

  factory LeaveLog.fromJson(Map<String, dynamic> json) => LeaveLog(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        day: json["day"],
        submitTime: DateTime.parse(json["submit_time"]),
        updateTime: DateTime.parse(json["update_time"]),
        reason: json["reason"],
        totalTime: json["total_time"],
        empId: json["emp_id"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "day": day,
        "submit_time": submitTime.toIso8601String(),
        "update_time": updateTime.toIso8601String(),
        "reason": reason,
        "total_time": totalTime,
        "emp_id": empId,
        "type": type,
      };
}
