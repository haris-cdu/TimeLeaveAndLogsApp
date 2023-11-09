import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/functions.dart';
import '../constants/responsive.dart';
import '../provider/graphdata_provider.dart';

class LeaveLogPage extends StatelessWidget {
  const LeaveLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GraphDataProvider>(
      builder: (context, provider, child) => provider.leaveLog.isEmpty
          ? Center(
              child: Text(
              "No leave logs!",
              style: TextStyle(
                  fontSize: dp(context, 20), fontWeight: FontWeight.bold),
            ))
          : ListView.builder(
              itemCount: provider.leaveLog.length,
              itemBuilder: (context, index) => Card(
                child: ExpansionTile(
                    title: Text(
                      formatWorkLogDate(provider.leaveLog[index].date),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Time taken: ${provider.leaveLog[index].totalTime}",
                                style: TextStyle(
                                  fontSize: dp(context, 16),
                                ),
                              ),
                              Text(
                                "Reason: ${provider.leaveLog[index].reason}",
                                style: TextStyle(
                                  fontSize: dp(context, 16),
                                ),
                              ),
                              Text(
                                "Leave-type: ${provider.leaveLog[index].type}",
                                style: TextStyle(
                                  fontSize: dp(context, 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
    );
  }
}
