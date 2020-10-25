import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'class/contenedor.dart';
import 'page/modal.dart';

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
  var listadatos;
  var _listaContenedores = <Contenedor>[];

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    super.initState();
    changeList();
  }

  void changeList() async {
    listadatos = await _loadCsvData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(children: listContainer()),
      ),
    );
  }

  List<Widget> listContainer() {
    return <Widget>[
      if (listadatos != null) ...{
        Row(
          children: <Widget>[
            for (var i = 0; i < lista.length; i++) ...{
              Expanded(
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        border: Border.all(color: Colors.lightBlue)),
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
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GridView.count(
              padding: const EdgeInsets.all(1),
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              crossAxisCount: 6,
              children: listaRow(),
            )
            // Center(
            //   child: FutureBuilder(
            //       future: _loadCsvData(),
            //       builder: (_, AsyncSnapshot<List<dynamic>> snapshot) {
            //         if (snapshot.hasData) {
            //           return Column(
            //               children: snapshot.data
            //                   .map((row) => new Padding(
            //                         padding: const EdgeInsets.symmetric(vertical: 1),
            //                         child: Row(
            //                             mainAxisAlignment:
            //                                 MainAxisAlignment.spaceBetween,
            //                             crossAxisAlignment: CrossAxisAlignment.center,
            //                             children: listaRow(row)
            //                             //Text(row['H']),

            //                             ),
            //                       ))
            //                   .toList());
            //         }
            //         return Align(
            //             alignment: Alignment.bottomCenter,
            //             child: new Padding(
            //                 padding: const EdgeInsets.symmetric(vertical: 250),
            //                 child: Column(
            //                   children: [
            //                     new CircularProgressIndicator(),
            //                     new Text(
            //                       "Loading",
            //                       style: TextStyle(fontSize: 20),
            //                     ),
            //                   ],
            //                 )));
            //       }),
            // ),
            )
      } else ...{
        Align(
            alignment: Alignment.bottomCenter,
            child: new Padding(
                padding: const EdgeInsets.symmetric(vertical: 250),
                child: Column(children: [
                  new CircularProgressIndicator(),
                  new Text(
                    "Loading",
                    style: TextStyle(fontSize: 20),
                  ),
                ]))),
      }
    ];
  }

  List<Widget> listaRow() {
    return <Widget>[
      for (var i = 0; i < listadatos.length; i++) ...{
        Row(children: [Text(listadatos[i]['H'])]),
        for (var x = 0; x < 5; x++) ...{
          InkWell(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.purple,
                    border: Border.all(color: Colors.white)),
                child: Column(
                  children: [],
                )),
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: true,
                  pageBuilder: (BuildContext context, _, __) {
                    return Modal();
                  },
                ),
              );
              //showDialog(context:context,
              //  child:AlertDialog(content:Modal(),
              //  )
              //);
            },
          )
        }
      }
    ];
  }

  Future<List<dynamic>> _loadCsvData() async {
    final response =
        await http.get('https://api.apispreadsheets.com/data/2351/');
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse['data'];
    }
    return null;
  }
}
