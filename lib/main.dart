import 'package:flutter/material.dart';
import 'package:calendar/widget/calendarList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar',
      theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.black,
          cardColor: Colors.grey[200],
          canvasColor: Colors.grey[300],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          backgroundColor: Colors.white),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.pink, // New
          accentColor: Colors.grey[350],
          cardColor: Colors.grey[900],
          canvasColor: Colors.black,
          backgroundColor: Colors.black // New
          ),
      home: MyHomePage(title: 'Calendar'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(child: CalendarList()),
    );
  }
}
