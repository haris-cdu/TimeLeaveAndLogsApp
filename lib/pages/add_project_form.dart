import 'package:employee_timesheet/model/graph_data_model.dart' as graph_model;
import 'package:employee_timesheet/provider/graphdata_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/functions.dart';
import '../constants/responsive.dart';
import '../constants/styles.dart';
import '../model/add_project_model.dart';
import 'leave_dialogue.dart';

class AddProjectForm extends StatefulWidget {
  final DateTime date;
  const AddProjectForm({Key? key, required this.date}) : super(key: key);

  @override
  AddProjectFormFormState createState() => AddProjectFormFormState();
}

class AddProjectFormFormState extends State<AddProjectForm> {
  late DateTime selectedDate;
  List<Project> projects = [];
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController taskNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int totalTime = 1;
  String leaveType = "Full day";

  @override
  void initState() {
    super.initState();
    selectedDate = widget.date;
  }

  void addProject() {
    setState(() {
      projects.add(Project(projectName: projectNameController.text, tasks: []));
      projectNameController.clear();
    });
  }

  void addTask(Project project) {
    setState(() {
      project.tasks.add(Task(
          taskName: taskNameController.text, totalTime: "$totalTime:00:00"));
      taskNameController.clear();
    });
  }

  void removeProject(Project project) {
    setState(() {
      projects.remove(project);
    });
  }

  void removeTask(Project project, Task task) {
    setState(() {
      project.tasks.remove(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Consumer<GraphDataProvider>(
        builder: (context, provider, child) => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            backgroundColor: Colors.deepPurpleAccent,
            title: const Text(
              "Add Project & Leaves",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formatWorkLogDate(selectedDate),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      SizedBox(
                        width: wp(context, 5),
                      ),
                      InkWell(
                          onTap: () async {
                            final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 365)),
                                lastDate: DateTime.now());

                            if (pickedDate != null &&
                                pickedDate != selectedDate) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                              provider.getGraphDetails(selectedDate);
                            }
                          },
                          child: const Icon(Icons.mode_edit_outline_rounded))
                    ],
                  ),
                ),
                TabBar(
                  tabs: [
                    Tab(child: Text("Working Log", style: tabbarStyle)),
                    Tab(child: Text("Leave Log", style: tabbarStyle)),
                  ],
                ),
                SizedBox(
                  height: hp(context, 1),
                ),
                Expanded(
                  child: TabBarView(children: [
                    addProjectAndTask(provider),
                    addLeaveLogs(provider)
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addProjectAndTask(GraphDataProvider provider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a project name";
                    }
                    return null;
                  },
                  controller: projectNameController,
                  decoration: const InputDecoration(labelText: 'Project Name'),
                ),
                SizedBox(
                  height: hp(context, 1),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addProject();
                      projectNameController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.deepPurpleAccent.withOpacity(0.4)),
                  child: const Text(
                    'Add Project',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                for (var project in projects)
                  ExpansionTile(
                    title: Text(
                      project.projectName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    onExpansionChanged: (expanded) {
                      if (!expanded) {
                        projectNameController.text = project.projectName;
                      }
                    },
                    trailing: Wrap(
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => removeProject(project),
                        ),
                        const IconButton(
                          icon: Icon(Icons.add),
                          onPressed: null,
                        ),
                      ],
                    ),
                    childrenPadding: const EdgeInsets.symmetric(horizontal: 25),
                    children: [
                      TextFormField(
                        controller: taskNameController,
                        decoration:
                            const InputDecoration(labelText: 'Task Name'),
                      ),
                      Row(
                        children: [
                          const Text(
                            "Hours worked: ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: wp(context, 10),
                          ),
                          DropdownButton(
                              value: totalTime,
                              items:
                                  [1, 2, 3, 4, 5, 6, 7, 8, 9].map((int items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text("$items"),
                                );
                              }).toList(),
                              onChanged: (value) {
                                totalTime = value!;
                                setState(() {});
                              }),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          addTask(project);
                          projectNameController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.deepPurpleAccent.withOpacity(0.4)),
                        child: const Text(
                          'Add Task',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      for (var task in project.tasks)
                        ListTile(
                          title: Text(
                            task.taskName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          subtitle: Text(
                            "Hours: ${task.totalTime}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => removeTask(project, task),
                          ),
                        ),
                    ],
                  ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.deepPurpleAccent.withOpacity(0.6)),
                    onPressed: () async {
                      provider.setLoading(true);
                      int status = await provider.addProjectAndTasks(
                          selectedDate, projects);
                      provider.setLoading(false);
                      Navigator.of(context).pop();
                      provider.getGraphDetails(selectedDate);
                      if (status == 1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Project added successfully!")));
                      } else if (status == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Record already inserted!")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Something went wrong! Try again")));
                      }
                    },
                    child: provider.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Save",
                            style: TextStyle(
                                color: Colors.black, fontSize: dp(context, 20)),
                          ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget addLeaveLogs(GraphDataProvider provider) {
    TextEditingController reasonController = TextEditingController();
    if (checkIfLeaveAdded(selectedDate, provider.leaveLog) != null) {
      graph_model.LeaveLog leave =
          checkIfLeaveAdded(selectedDate, provider.leaveLog);
      return Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.black, width: 1)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Leave-type: ${leave.type}",
                    style: leaveStyle,
                  ),
                  Text(
                    "Leave-reason: ${leave.reason}",
                    style: leaveStyle,
                  ),
                  Text(
                    "Leave-time: ${leave.totalTime}",
                    style: leaveStyle,
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.deepPurpleAccent.withOpacity(0.6)),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return LeaveDialog(
                          onLeaveTypeChanged: (value) {
                            setState(() {
                              leaveType = value;
                            });
                          },
                          dateTime: selectedDate,
                          leaveId: leave.id,
                          leaveType: leave.type,
                          reason: leave.reason,
                        );
                      },
                    );
                  },
                  child: const Text("Edit")),
              SizedBox(
                width: wp(context, 2),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('Are you sure?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    provider.deleteLeave(leave.id);
                                    provider.getGraphDetails(selectedDate);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('No'),
                                ),
                              ],
                            ));
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          )
        ],
      );
    }
    return SingleChildScrollView(
        child: Column(
      children: [
        Row(
          children: [
            const Text(
              "Select leave type: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: wp(context, 5),
            ),
            DropdownButton(
                value: leaveType,
                items: ["Full day", "Half day", "Early going", "Late coming"]
                    .map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    leaveType = value!;
                  });
                }),
          ],
        ),
        SizedBox(
          height: hp(context, 1),
        ),
        TextFormField(
          controller: reasonController,
          decoration: const InputDecoration(labelText: 'Reason'),
        ),
        SizedBox(
          height: hp(context, 1),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent.withOpacity(0.6)),
            onPressed: () async {
              provider.setLoading(true);
              int status = await provider.addLeaveLogs(
                  selectedDate, leaveType, reasonController.text);
              provider.setLoading(false);
              Navigator.of(context).pop();
              provider.getGraphDetails(selectedDate);
              if (status == 1) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Leave added successfully!")));
              } else if (status == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Leave already inserted!")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Something went wrong! Try again")));
              }
            },
            child: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.black, fontSize: dp(context, 20)),
                  ))
      ],
    ));
  }
}
