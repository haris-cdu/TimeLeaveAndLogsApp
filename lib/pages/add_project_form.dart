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
  const AddProjectForm({Key? key}) : super(key: key);

  @override
  AddProjectFormFormState createState() => AddProjectFormFormState();
}

class AddProjectFormFormState extends State<AddProjectForm> {
  List<Project> projects = [];
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController taskNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int totalTime = 1;
  String leaveType = "Early going";
  int totalWorkingHours = 0;
  int totalLeaveHours = 0;

  void addProject() {
    setState(() {
      projects.add(Project(projectName: projectNameController.text, tasks: []));
      projectNameController.clear();
    });
  }

  void addTask(Project project) {
    setState(() {
      project.tasks.add(Task(
          taskName: taskNameController.text.isEmpty
              ? "Subtask"
              : taskNameController.text,
          totalTime: "$totalTime:00:00"));
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
            backgroundColor: Colors.teal,
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
                        formatWorkLogDate(provider.selectedDate),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      SizedBox(
                        width: wp(context, 5),
                      ),
                      InkWell(
                          onTap: () async {
                            provider.selectDate(context);
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
    if (checkIfWorkingLogAdded(provider.selectedDate, provider.workingLog) !=
        null) {
      graph_model.WorkingLog workingLog =
          checkIfWorkingLogAdded(provider.selectedDate, provider.workingLog);
      return ListView.builder(
        padding: const EdgeInsets.all(10),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: workingLog.projectLog.length,
        itemBuilder: (context, index) => Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.black, width: 1)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  workingLog.projectLog[index].projectName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(
                  color: Colors.black,
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: workingLog.projectLog[index].tasks.length,
                  itemBuilder: (context, i) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "--> Task: ${workingLog.projectLog[index].tasks[i].taskName}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "\t\t\t\t\t Time: ${workingLog.projectLog[index].tasks[i].totalTime}",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    if (checkIfLeaveAdded(provider.selectedDate, provider.leaveLog) != null) {
      graph_model.LeaveLog leaveLog =
          checkIfLeaveAdded(provider.selectedDate, provider.leaveLog);
      if (leaveLog.id != 0 && totalWorkingHours == 0) {
        totalWorkingHours = convertFromTime(leaveLog.totalTime);
      }
    }
    return WillPopScope(
      onWillPop: () async {
        resetTotalWorkingHours();
        return true;
      },
      child: SingleChildScrollView(
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
                    decoration:
                        const InputDecoration(labelText: 'Project Name'),
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
                        backgroundColor: Colors.teal.withOpacity(0.8)),
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
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                int taskHours = 0;
                                for (int i = 0; i < project.tasks.length; i++) {
                                  taskHours += convertFromTime(
                                      project.tasks[i].totalTime);
                                }
                                removeProject(project);
                                totalWorkingHours -= taskHours;
                              }),
                          const IconButton(
                            icon: Icon(Icons.add),
                            onPressed: null,
                          ),
                        ],
                      ),
                      childrenPadding:
                          const EdgeInsets.symmetric(horizontal: 25),
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
                                    [1, 2, 3, 4, 5, 6, 7, 8].map((int items) {
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
                            int tempHours = totalWorkingHours + totalTime;
                            print(tempHours);
                            if (tempHours <= 8) {
                              addTask(project);
                              setState(() {
                                totalWorkingHours += totalTime;
                              });
                              projectNameController.clear();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Maximum hours are added already!")));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(
                                  double.maxFinite, double.minPositive),
                              backgroundColor: Colors.teal.withOpacity(0.8)),
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
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    totalWorkingHours -=
                                        convertFromTime(task.totalTime);
                                  });
                                  removeTask(project, task);
                                }),
                          ),
                      ],
                    ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.withOpacity(0.8)),
                      onPressed: () async {
                        if (projects.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please add projects first!")));
                        } else {
                          provider.setLoading(true);
                          int status =
                              await provider.addProjectAndTasks(projects);
                          provider.setLoading(false);
                          Navigator.of(context).pop();
                          provider.getGraphDetails();
                          resetTotalWorkingHours();
                          if (status == 1) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Project added successfully!")));
                          } else if (status == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Record already inserted!")));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Something went wrong! Try again")));
                          }
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
                                  color: Colors.black,
                                  fontSize: dp(context, 20)),
                            ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addLeaveLogs(GraphDataProvider provider) {
    TextEditingController reasonController = TextEditingController();
    if (checkIfLeaveAdded(provider.selectedDate, provider.leaveLog) != null) {
      graph_model.LeaveLog leave =
          checkIfLeaveAdded(provider.selectedDate, provider.leaveLog);
      if (leave.id != 0) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.black, width: 1)),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                width: wp(context, 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Leave Card",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    Text(
                      "Type: ${leave.type}",
                      style: leaveStyle,
                    ),
                    Text(
                      "Reason: ${leave.reason}",
                      style: leaveStyle,
                    ),
                    Text(
                      "Time: ${leave.totalTime}",
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
                        backgroundColor: Colors.teal.withOpacity(0.8)),
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
                              leaveId: leave.id);
                        },
                      );
                    },
                    child: const Text(
                      "Edit",
                      style: TextStyle(color: Colors.black),
                    )),
                SizedBox(
                  width: wp(context, 2),
                ),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text(
                                    'Are you sure you want to delete?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      provider.deleteLeave(leave.id);
                                      provider.getGraphDetails();
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
    }
    if (checkIfWorkingLogAdded(provider.selectedDate, provider.workingLog) !=
        null) {
      totalLeaveHours = 0;
      graph_model.WorkingLog workingLog =
          checkIfWorkingLogAdded(provider.selectedDate, provider.workingLog);
      for (int i = 0; i < workingLog.projectLog.length; i++) {
        for (int j = 0; j < workingLog.projectLog[i].tasks.length; j++) {
          String time = workingLog.projectLog[i].tasks[j].totalTime;
          totalLeaveHours += convertFromTime(time);
        }
      }
      print("TotalLeaveHours: $totalLeaveHours");
    }
    return totalLeaveHours <= 6
        ? SingleChildScrollView(
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
                  totalLeaveHours == 0
                      ? DropdownButton(
                          value: leaveType,
                          items: [
                            "Full day",
                            "Half day",
                            "Early going",
                            "Late coming"
                          ].map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              leaveType = value!;
                            });
                          })
                      : totalLeaveHours <= 4
                          ? DropdownButton(
                              value: leaveType,
                              items: ["Half day", "Early going", "Late coming"]
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
                              })
                          : totalLeaveHours <= 6
                              ? DropdownButton(
                                  value: leaveType,
                                  items: ["Early going", "Late coming"]
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
                                  })
                              : Container()
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
                      backgroundColor: Colors.teal.withOpacity(0.8)),
                  onPressed: () async {
                    provider.setLoading(true);
                    int status = await provider.addLeaveLogs(
                        leaveType, reasonController.text);
                    provider.setLoading(false);
                    Navigator.of(context).pop();
                    provider.getGraphDetails();
                    if (status == 1) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Leave added successfully!")));
                    } else if (status == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Leave already inserted!")));
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
          ))
        : Center(
            child: Text(
            "Was a fully working day!",
            style: TextStyle(
                fontSize: dp(context, 20), fontWeight: FontWeight.bold),
          ));
  }

  void resetTotalWorkingHours() {
    setState(() {
      totalWorkingHours = 0;
    });
  }
}
