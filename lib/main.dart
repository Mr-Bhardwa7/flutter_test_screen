import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> week = <String>['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  final List<String> date = <String>['30', '31', '1', '2', '3', '4', '5'];
  int _selectedItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: header(),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TopRow(),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    7,
                    (index) => DateWidget(day: week[index], date: date[index]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
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
    );
  }

  Container buildNavBarItem(
      BuildContext context, IconData icon, int index, bool isCenter) {
    return Container(
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

class DateWidget extends StatefulWidget {
  DateWidget({this.day, this.date});
  final String day;
  final String date;

  @override
  _DateWidgetState createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  bool _selectedDate = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedDate = !_selectedDate;
        });
      },
      child: Container(
        decoration: !_selectedDate
            ? null
            : BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50.0))),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.day,
              style: TextStyle(
                  color: !_selectedDate
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  fontWeight:
                      !_selectedDate ? FontWeight.normal : FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              widget.date,
              style: TextStyle(
                  color: !_selectedDate
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  fontWeight:
                      !_selectedDate ? FontWeight.normal : FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class TopRow extends StatelessWidget {
  TopRow({
    Key key,
  }) : super(key: key);

  final TextStyle _style = TextStyle(color: Colors.white, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'September,',
          style: _style,
        ),
        Text(
          ' 2020',
          style: _style,
        ),
      ],
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
