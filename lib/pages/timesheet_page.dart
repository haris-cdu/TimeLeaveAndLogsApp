import 'package:employee_timesheet/constants/functions.dart';
import 'package:employee_timesheet/constants/responsive.dart';
import 'package:employee_timesheet/constants/styles.dart';
import 'package:employee_timesheet/data/services/api_service.dart';
import 'package:employee_timesheet/pages/leavelog_page.dart';
import 'package:employee_timesheet/pages/worklog_page.dart';
import 'package:employee_timesheet/provider/graphdata_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimeSheetPage extends StatefulWidget {
  const TimeSheetPage({super.key});

  @override
  State<TimeSheetPage> createState() => _TimeSheetPageState();
}

class _TimeSheetPageState extends State<TimeSheetPage> {
  DateTime selectedDate = DateTime.now();
  bool isLoading = true;

  @override
  void initState() {
    ApiService().setBaseToken(
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTkyLjE2OC4wLjE4MS9teWNvbXBhbnkvcHVibGljL2FwaS9sb2dpbiIsImlhdCI6MTY5OTM0MDkzMiwiZXhwIjoxNzMwODk4NTMyLCJuYmYiOjE2OTkzNDA5MzIsImp0aSI6IjlRcGtJMUQ4bW1NaXdEVG8iLCJzdWIiOiIxNiIsInBydiI6ImIyYWViMjkyOGNiMjVkMmYzMTYzMjBmOTc4ODdlOWM4NThlZjc3ODIifQ.rdahSieFNVDhL9usM7tJBpa4SSH6_WoMmU9yr1YB3Jk");
    final model = Provider.of<GraphDataProvider>(context, listen: false);
    model.getGraphDetails(DateTime.now());
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;
    });
    setState(() {});
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
                // Navigator.pop(context, true);
              },
            ),
            backgroundColor: Colors.blue,
            title: const Text(
              "TimeSheet",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  color: Colors.blue.withOpacity(0.35),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Hours worked",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: dp(context, 15)))),
                          SizedBox(
                            width: wp(context, 8),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: hp(context, 2),
                                    width: wp(context, 3),
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: wp(context, 1),
                                  ),
                                  const Text("Working"),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: hp(context, 2),
                                    width: wp(context, 3),
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: wp(context, 1),
                                  ),
                                  const Text("Sick/WeekOff"),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                height: hp(context, 2),
                                width: wp(context, 3),
                                color: Colors.orange,
                              ),
                              SizedBox(
                                width: wp(context, 1),
                              ),
                              const Text("casual"),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: hp(context, 1),
                      ),
                      SizedBox(
                        height: hp(context, 45),
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : BarChart(BarChartData(
                                titlesData: const FlTitlesData(
                                    rightTitles: AxisTitles(),
                                    topTitles: AxisTitles()),
                                borderData: FlBorderData(
                                    border: const Border(
                                        top: BorderSide.none,
                                        right: BorderSide.none,
                                        left: BorderSide(width: 1),
                                        bottom: BorderSide(width: 1))),
                                groupsSpace: 8,
                                barGroups: [
                                    BarChartGroupData(
                                        x: provider.data[6].date.day,
                                        barRods: getBarChartRodData(
                                            provider.data[6])),
                                    BarChartGroupData(
                                        x: provider.data[5].date.day,
                                        barRods: getBarChartRodData(
                                            provider.data[5])),
                                    BarChartGroupData(
                                        x: provider.data[4].date.day,
                                        barRods: getBarChartRodData(
                                            provider.data[4])),
                                    BarChartGroupData(
                                        x: provider.data[3].date.day,
                                        barRods: getBarChartRodData(
                                            provider.data[3])),
                                    BarChartGroupData(
                                        x: provider.data[2].date.day,
                                        barRods: getBarChartRodData(
                                            provider.data[2])),
                                    BarChartGroupData(
                                        x: provider.data[1].date.day,
                                        barRods: getBarChartRodData(
                                            provider.data[1])),
                                    BarChartGroupData(
                                        x: provider.data[0].date.day,
                                        barRods: getBarChartRodData(
                                            provider.data[0])),
                                  ])),
                      ),
                      Text(
                        "Weekly log",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: dp(context, 15)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              selectedDate = selectedDate
                                  .subtract(const Duration(days: 7));
                              setState(() {});
                              provider.getGraphDetails(selectedDate);
                            },
                            child: Icon(
                              Icons.arrow_circle_left_outlined,
                              size: dp(context, 35),
                            ),
                          ),
                          SizedBox(
                            width: wp(context, 3),
                          ),
                          Center(
                            child: isLoading
                                ? const Text("")
                                : Text(
                                    "${formatDatePicker(provider.data[6].date)} to ${formatDatePicker(provider.data[0].date)}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: dp(context, 15)),
                                  ),
                          ),
                          SizedBox(
                            width: wp(context, 3),
                          ),
                          InkWell(
                            onTap: () {
                              if (selectedDate.isBefore(DateTime.now()
                                  .subtract(const Duration(days: 1)))) {
                                selectedDate =
                                    selectedDate.add(const Duration(days: 7));
                                setState(() {});
                                provider.getGraphDetails(selectedDate);
                              }
                            },
                            child: Icon(
                              Icons.arrow_circle_right_outlined,
                              size: dp(context, 35),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                TabBar(
                  tabs: [
                    Tab(child: Text("Work Log", style: tabbarStyle)),
                    Tab(child: Text("Leave Log", style: tabbarStyle)),
                  ],
                ),
                SizedBox(height: hp(context, 2)),
                SizedBox(
                  width: wp(context, 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.calendar_month),
                      Text(
                        formatDatePicker(selectedDate),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
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
                const Expanded(
                    child:
                        TabBarView(children: [WorkLogPage(), LeaveLogPage()]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
