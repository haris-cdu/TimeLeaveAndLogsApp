import 'package:employee_timesheet/constants/responsive.dart';
import 'package:employee_timesheet/provider/graphdata_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/add_project_model.dart';

class AddProjectForm extends StatefulWidget {
  const AddProjectForm({super.key});

  @override
  _AddProjectFormFormState createState() => _AddProjectFormFormState();
}

class _AddProjectFormFormState extends State<AddProjectForm> {
  List<Project> projects = [];
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController totalTimeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void addProject() {
    setState(() {
      projects.add(Project(projectName: projectNameController.text, tasks: []));
      projectNameController.clear();
    });
  }

  void addTask(Project project) {
    setState(() {
      project.tasks.add(Task(
          taskName: taskNameController.text,
          totalTime: totalTimeController.text));
      taskNameController.clear();
      totalTimeController.clear();
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
          child: Form(
            key: _formKey,
            child: ListView(
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
                      TextFormField(
                        controller: totalTimeController,
                        decoration: const InputDecoration(
                            labelText: 'Total Time', hintText: "hh:mm:ss"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          addTask(project);
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
                            task.totalTime,
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
                      int status = await provider.addProjectAndTasks(projects);
                      provider.setLoading(false);
                      Navigator.of(context).pop();
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
        ),
      ),
    );
  }
}
