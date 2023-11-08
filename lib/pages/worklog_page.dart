import 'package:employee_timesheet/constants/functions.dart';
import 'package:employee_timesheet/provider/graphdata_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkLogPage extends StatelessWidget {
  const WorkLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GraphDataProvider>(
      builder: (context, provider, child) => ListView.builder(
        // physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: provider.workingLog.length,
        itemBuilder: (context, index) => Card(
          child: ExpansionTile(
              title: Text(
                formatWorkLogDate(provider.workingLog[index].date),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              children: [
                ListView.builder(
                  itemCount: provider.workingLog[index].projectLog.length,
                  itemBuilder: (context, logIndex) => Column(
                    children: [
                      Text(provider
                          .workingLog[index].projectLog[logIndex].projectName),
                      ListView.builder(
                        itemCount: provider.workingLog[index]
                            .projectLog[logIndex].tasks.length,
                        itemBuilder: (context, taskIndex) => Text(provider
                            .workingLog[index]
                            .projectLog[logIndex]
                            .tasks[taskIndex]
                            .taskName),
                      )
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
