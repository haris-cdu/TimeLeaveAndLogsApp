import 'package:employee_timesheet/constants/functions.dart';
import 'package:employee_timesheet/constants/responsive.dart';
import 'package:employee_timesheet/provider/graphdata_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkLogPage extends StatelessWidget {
  const WorkLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GraphDataProvider>(
      builder: (context, provider, child) => provider.workingLog.isEmpty
          ? Center(
              child: Text(
              "No working logs!",
              style: TextStyle(
                  fontSize: dp(context, 20), fontWeight: FontWeight.bold),
            ))
          : ListView.builder(
              itemCount: provider.workingLog.length,
              itemBuilder: (context, index) => Card(
                child: ExpansionTile(
                    title: Text(
                      formatWorkLogDate(provider.workingLog[index].date),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: provider.workingLog[index].projectLog.length,
                        itemBuilder: (context, logIndex) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 15),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  provider.workingLog[index]
                                      .projectLog[logIndex].projectName,
                                  style: TextStyle(
                                      fontSize: dp(context, 16),
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: provider.workingLog[index]
                                    .projectLog[logIndex].tasks.length,
                                itemBuilder: (context, taskIndex) => Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "-> ${provider.workingLog[index].projectLog[logIndex].tasks[taskIndex].taskName}",
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ]),
              ),
            ),
    );
  }
}
