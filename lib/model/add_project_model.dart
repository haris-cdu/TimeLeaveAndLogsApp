class Project {
  final String projectName;
  final List<Task> tasks;

  Project({
    required this.projectName,
    required this.tasks,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        projectName: json["project_name"],
        tasks: List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "project_name": projectName,
        "tasks": List<dynamic>.from(tasks.map((x) => x.toJson())),
      };
}

class Task {
  String taskName;
  String totalTime;

  Task({
    required this.taskName,
    required this.totalTime,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        taskName: json["task_name"],
        totalTime: json["total_time"],
      );

  Map<String, dynamic> toJson() => {
        "task_name": taskName,
        "total_time": totalTime,
      };
}
