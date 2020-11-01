import 'package:flutter/material.dart';
import 'model/contenedor.dart';
import 'page/modal.dart';
import 'api/apiConection.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:calendar/model/doubleRow.dart';

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
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  var listadias = ['', 'L', 'M', 'X', 'J', 'V'];
  var listadatos;
  List _listaContenedores = [];
  var contenedores = <Contenedor>[];
  List listaColumnas = <DoubleRow>[];
  List<StaggeredTile> staggeredTiles = <StaggeredTile>[];

  List dataList(int i, String day, String texto) {
    setState(() {
      listadatos[i][day] = texto;
    });
    return listadatos;
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    super.initState();
    changeList();
  }

  void changeList() async {
    List respuesta = await ApiConection().loadCsvData();
    listadatos = respuesta;
    addContainers(respuesta.length - 1);
    setState(() {});
  }

  void addContainers(int index) async {
    if (listadatos != null) {
      for (int i = 0; i < index; i++) {
        staggeredTiles.add(const StaggeredTile.count(1, 1));
        contenedores = <Contenedor>[];
        for (int x = 0; x < 5; x++) {
          addContainer(i, x);
        }
        addContainerRow();
        setState(() {});
      }
      staggeredTiles.add(const StaggeredTile.count(1, 1));
      setState(() {});
    }
  }

  void addContainer(int i, int x) {
    var contains = false;
    for (int z = 0; z < listaColumnas.length; z++) {
      if (listaColumnas[z].index1 == i && listaColumnas[z].index2 == x) {
        contains = true;
      }
    }
    if (listadatos[i][listadias[x + 1]] != "" && !contains) {
      var datos = listadatos[i][listadias[x + 1]].split("|");
      String color = datos[1];
      color = color.replaceAll("Color(", "");
      Color c = Color(int.parse(color.replaceAll(")", "")));
      contenedores.add(Contenedor(c, datos[0], int.parse(datos[2])));
      if (datos[2] == "2") {
        staggeredTiles.add(const StaggeredTile.count(1, 2));
        listaColumnas.add(DoubleRow(i + 1, x));
      } else {
        staggeredTiles.add(const StaggeredTile.count(1, 1));
      }
    } else if (!contains) {
      contenedores.add(Contenedor(Colors.white, "", 1));
      staggeredTiles.add(const StaggeredTile.count(1, 1));
    }
    setState(() {});
  }

  void addContainerRow() {
    _listaContenedores.add(contenedores);
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
            for (var i = 0; i < listadias.length; i++) ...{
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
                          listadias[i],
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
            child: new StaggeredGridView.count(
              staggeredTiles: staggeredTiles,
              crossAxisCount: 6,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
              padding: const EdgeInsets.all(0),
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
          Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(listadatos[i]['H'])))
        ]),
        if (i != listadatos.length - 1) ...{
          for (var x = 0; x < _listaContenedores[i].length; x++) ...{
            InkWell(
              child: Container(
                  decoration: BoxDecoration(
                      color: _listaContenedores[i][x].containerColor,
                      border: Border.all(color: Colors.black)),
                  alignment: Alignment.center,
                  child: Text(
                    _listaContenedores[i][x].text,
                  )),
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: true,
                    pageBuilder: (BuildContext context, _, __) {
                      return Modal(
                          contenedor: _listaContenedores[i][x],
                          index: i,
                          day: listadias[x + 1],
                          list: listadatos);
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
}
