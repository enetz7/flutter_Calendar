import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'model/contenedor.dart';
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
  var contenedores = <Contenedor>[];

  List _listaContenedores = [];

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    super.initState();
    changeList();
    print(listadatos);
  }

  void addContainers(int index) async {
    if (listadatos != null) {
      for (int i = 0; i < index; i++) {
        contenedores = <Contenedor>[];
        for (int x = 0; x < 5; x++) {
          addContainer(i, x);
        }
        addContainerRow();
      }
      setState(() {});
    }
  }

  void changeList() async {
    List respuesta = await _loadCsvData();
    listadatos = respuesta;
    addContainers(respuesta.length - 1);
    setState(() {});
  }

  void addContainerRow() {
    _listaContenedores.add(contenedores);
    setState(() {});
  }

  void addContainer(int i, int x) {
    if (listadatos[i][lista[x + 1]] != "") {
      var datos = listadatos[i][lista[x + 1]].split("|");
      String color = datos[1];
      color = color.replaceAll("Color(", "");
      Color c = Color(int.parse(color.replaceAll(")", "")));
      contenedores.add(Contenedor(c, datos[0]));
    } else {
      contenedores.add(Contenedor(Colors.white, ""));
    }
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
      if (listadatos != null && _listaContenedores != null) ...{
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
              padding: const EdgeInsets.all(0),
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: 6,
              children: listaRow(),
            ))
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
        Row(children: [
          Align(alignment: Alignment.topLeft, child: Text(listadatos[i]['H']))
        ]),
        if (i != listadatos.length - 1) ...{
          for (var x = 0; x < 5; x++) ...{
            InkWell(
              child: Container(
                  decoration: BoxDecoration(
                      color: _listaContenedores[i][x].containerColor,
                      border: Border(
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black))),
                  alignment: Alignment.center,
                  child: Text(
                    _listaContenedores[i][x].note,
                  )),
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: true,
                    pageBuilder: (BuildContext context, _, __) {
                      return Modal(contenedor: _listaContenedores[i][x]);
                    },
                  ),
                );
              },
            )
          }
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
