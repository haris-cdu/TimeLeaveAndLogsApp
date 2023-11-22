import 'package:employee_timesheet/constants/responsive.dart';
import 'package:employee_timesheet/provider/graphdata_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaveDialog extends StatefulWidget {
  final DateTime dateTime;
  final int leaveId;
  final String leaveType;
  final String reason;
  final Function(String) onLeaveTypeChanged;

  const LeaveDialog(
      {super.key,
      required this.dateTime,
      required this.leaveId,
      required this.leaveType,
      required this.reason,
      required this.onLeaveTypeChanged});

  @override
  _LeaveDialogState createState() => _LeaveDialogState();
}

class _LeaveDialogState extends State<LeaveDialog> {
  String leaveType = "Full day";

  @override
  Widget build(BuildContext context) {
    return Consumer<GraphDataProvider>(
      builder: (context, provider, child) => AlertDialog(
        title: const Text('Edit Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  "Select type: ",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: wp(context, 2),
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
                    widget.onLeaveTypeChanged(
                        leaveType); // Notify parent about the change
                  },
                ),
              ],
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Leave reason'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              provider.setLoading(true);
              int status = await provider.updateLeave(widget.dateTime,
                  widget.leaveId, widget.leaveType, widget.reason);
              provider.setLoading(false);
              Navigator.of(context).pop();
              if (status == 1) {
                provider.getGraphDetails(widget.dateTime);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Leave updated successfully!")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Something went wrong! Try again")));
              }
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
