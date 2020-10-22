import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var lista = ['', 'L', 'M', 'X', 'J', 'V'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: listContainer(),
          ),
        ));
  }

  List<Widget> listContainer() {
    return <Widget>[
      Row(
        children: <Widget>[
          for (var i = 0; i < lista.length; i++) ...{
            Expanded(
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                  ),
                  child: Column(
                    children: [
                      Text(
                        lista[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  )),
            )
          }
        ],
      ),
      Center(
        child: FutureBuilder(
            future: _loadCsvData(),
            builder: (_, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                return Column(
                    children: snapshot.data
                        .map((row) => new Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: listaRow(row)
                                  //Text(row['H']),

                                  ),
                            ))
                        .toList());
              }
              return Align(
                  alignment: Alignment.bottomCenter,
                  child: new Padding(
                      padding: const EdgeInsets.symmetric(vertical: 250),
                      child: Column(
                        children: [
                          new CircularProgressIndicator(),
                          new Text(
                            "Loading",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      )));
            }),
      ),
    ];
  }

  List<Widget> listaRow(row) {
    return <Widget>[
      Text(row['H']),
      for (var i = 0; i < 5; i++) ...{
        Expanded(
            child: InkWell(
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  border: Border.all(color: Colors.white)),
              child: Column(
                children: [],
              )),
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return CreateModal();
                },
              ),
            );
          },
        ))
      }
    ];
  }

  Future<List<dynamic>> _loadCsvData() async {
    final response = await http.get('https://api.apispreadsheets.com/data/2351/'
        //'https://api.sheety.co/2c5b1406a73797b34bafc46e169b285c/calendario/hoja1'
        );
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse['data'];
    }
    return null;
  }
}

class CreateModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Introducir clase"),
        ),
        body: Center(
          child: Container(
            height: 500,
            width: 500,
            child: RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Introduce la clase'),
            ),
          ),
        ));
  }
}
