import 'package:employee_timesheet/constants/functions.dart';
import 'package:employee_timesheet/constants/responsive.dart';
import 'package:employee_timesheet/provider/graphdata_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/add_project_model.dart';

class AddProjectForm extends StatefulWidget {
  final DateTime date;
  const AddProjectForm({super.key, required this.date});

  @override
  _AddProjectFormFormState createState() => _AddProjectFormFormState();
}

class _AddProjectFormFormState extends State<AddProjectForm> {
  late DateTime selectedDate;
  List<Project> projects = [];
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController taskNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int totalTime = 1;

  @override
  void initState() {
    selectedDate = widget.date;
    super.initState();
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
    return Consumer<GraphDataProvider>(
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
            "Add Project & tasks",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
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
                            }
                          },
                          child: const Icon(Icons.mode_edit_outline_rounded))
                    ],
                  ),
                ),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: wp(context, 10),
                                ),
                                DropdownButton(
                                    value: totalTime,
                                    items: [1, 2, 3, 4, 5, 6, 7, 8, 9]
                                        .map((int items) {
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
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                                subtitle: Text(
                                  "Hours: ${task.totalTime}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
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
                            if (status == 1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Project added successfully!")));
                            } else if (status == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Record already inserted!")));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Something went wrong! Try again")));
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
        ),
      ),
    );
  }
}
