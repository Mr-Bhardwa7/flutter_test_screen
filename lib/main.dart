import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  // runApp(MyApp());
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  int _selectedItemIndex = 0;
  String _focusMonth = DateFormat('MMMM, y').format(DateTime.now());
  AnimationController _animationController;
  CalendarController _calendarController;
  String _dropDownValue = 'Week';

  final List<Color> _colors = <Color>[Colors.blue, Colors.green, Colors.red];
  final List<IconData> _icons = <IconData>[
    Icons.videocam,
    Icons.computer,
    Icons.pages
  ];
  final List<String> _numbers = <String>['94', '17', '29'];
  final List<String> _titles = <String>[
    'Recorded Session',
    'Classes Assign',
    'Task Assign'
  ];

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
    setState(() {
      _focusMonth =
          DateFormat('MMMM, y').format(_calendarController.focusedDay);
    });
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: header(),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TopRow(month: _focusMonth),
            SizedBox(height: 10.0),
            _buildTableCalendar(),
            SizedBox(height: 10.0),
            Expanded(
              child: Container(
                padding: EdgeInsets.zero,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 2,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0))),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Dashboard',
                          style: TextStyle(fontSize: 18.0, letterSpacing: -0.5),
                        ),
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Container(
                        height: 150,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: List.generate(3, (int index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: _card(_colors[index], _icons[index],
                                    _numbers[index], _titles[index]),
                              );
                            })),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Session',
                              style: TextStyle(
                                  fontSize: 18.0, letterSpacing: -0.5),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.03),
                                      spreadRadius: 0,
                                      blurRadius: 0,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ]),
                              child: DropdownButton<String>(
                                value: _dropDownValue,
                                items: <String>['Week', 'Month']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                onChanged: (newVal) {
                                  setState(() {
                                    _dropDownValue = newVal;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 32.0, right: 32.0, top: 16.0),
                          margin: EdgeInsets.only(top: 8.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                ),
                              ]),
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 20,
                              barTouchData: BarTouchData(
                                enabled: false,
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: Colors.transparent,
                                  tooltipPadding: const EdgeInsets.all(0),
                                  tooltipBottomMargin: 8,
                                  getTooltipItem: (
                                    BarChartGroupData group,
                                    int groupIndex,
                                    BarChartRodData rod,
                                    int rodIndex,
                                  ) {
                                    return BarTooltipItem(
                                      rod.y.round().toString(),
                                      TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: SideTitles(
                                  showTitles: false,
                                ),
                                leftTitles: SideTitles(
                                  showTitles: true,
                                  textStyle: TextStyle(
                                      color: const Color(0xff7589a2),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                  getTitles: (value) {
                                    if (value == 1) {
                                      return '2h';
                                    } else if (value == 4) {
                                      return '4h';
                                    } else if (value == 7) {
                                      return '6h';
                                    } else if (value == 10) {
                                      return '8h';
                                    } else if (value == 13) {
                                      return '10h';
                                    } else if (value == 16) {
                                      return '12h';
                                    } else if (value == 19) {
                                      return '14h';
                                    } else {
                                      return '';
                                    }
                                  },
                                ),
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              barGroups: [
                                BarChartGroupData(x: 0, barRods: [
                                  BarChartRodData(
                                      y: 8, color: Colors.lightBlueAccent)
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 1, barRods: [
                                  BarChartRodData(
                                      y: 10, color: Colors.lightBlueAccent)
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 2, barRods: [
                                  BarChartRodData(
                                      y: 14, color: Colors.lightBlueAccent)
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 3, barRods: [
                                  BarChartRodData(
                                      y: 15, color: Colors.lightBlueAccent)
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 3, barRods: [
                                  BarChartRodData(
                                      y: 13, color: Colors.lightBlueAccent)
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 3, barRods: [
                                  BarChartRodData(
                                      y: 10, color: Colors.lightBlueAccent)
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 3, barRods: [
                                  BarChartRodData(
                                      y: 15, color: Colors.lightBlueAccent)
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        color: Colors.white,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: Row(
            children: [
              buildNavBarItem(context, Icons.menu, 0, false),
              buildNavBarItem(context, Icons.pending_actions, 1, false),
              buildNavBarItem(context, Icons.videocam, 2, true),
              buildNavBarItem(context, Icons.insert_drive_file, 3, false),
              buildNavBarItem(context, Icons.person_outline, 4, false),
            ],
          ),
        ),
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      initialCalendarFormat: CalendarFormat.week,
      headerVisible: false,
      availableCalendarFormats: {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.white),
          weekendStyle: TextStyle(color: Colors.white)),
      calendarStyle: CalendarStyle(
        weekdayStyle: TextStyle(color: Colors.white),
        weekendStyle: TextStyle(color: Colors.white),
        outsideWeekendStyle: TextStyle(color: Color(0xFF9E9E9E)),
        outsideDaysVisible: true,
      ),
      // onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget buildNavBarItem(
      BuildContext context, IconData icon, int index, bool isCenter) {
    return Container(
      padding: EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        child: Container(
            padding: EdgeInsets.only(right: 10.0, left: 10.0),
            height: 60,
            width: MediaQuery.of(context).size.width / 5,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: isCenter
                ? Container(
                    decoration: BoxDecoration(
                        color: Colors.lightBlue.withOpacity(0.6),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                : _selectedItemIndex != index
                    ? Icon(icon, color: Colors.grey, size: 30)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            icon,
                            color: Colors.orange,
                            size: 30,
                          ),
                          Text(
                            'Home',
                            style: TextStyle(color: Colors.orange),
                          )
                        ],
                      )),
        onTap: () {
          if (!isCenter) {
            setState(() {
              _selectedItemIndex = index;
            });
          }
        },
      ),
    );
  }
}

class TopRow extends StatelessWidget {
  TopRow({Key key, this.month}) : super(key: key);

  final String month;
  final TextStyle _style = TextStyle(color: Colors.white, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            month,
            style: _style,
          ),
        ],
      ),
    );
  }
}

Widget header() {
  return AppBar(
    elevation: 0.0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
        ),
        Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Hello, Alexa!',
              style: TextStyle(fontSize: 16),
            ))
      ],
    ),
    actions: [
      IconButton(
          icon: Icon(
            Icons.play_circle_outline,
            size: 30,
            color: Colors.white,
          ),
          onPressed: null),
      IconButton(
          icon: Icon(
            Icons.notifications_none,
            size: 30,
            color: Colors.white,
          ),
          onPressed: null),
    ],
  );
}

Widget _card(Color color, IconData icon, String number, String title) {
  return Container(
    padding: EdgeInsets.only(top: 16.0, bottom: 16.0, right: 32.0, left: 16.0),
    decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.all(Radius.circular(10.0))),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: color.withOpacity(0.6),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Icon(
            icon,
            color: Colors.white,
            size: 25,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Text(
          number,
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.6)),
        ),
        Text(title)
      ],
    ),
  );
}
