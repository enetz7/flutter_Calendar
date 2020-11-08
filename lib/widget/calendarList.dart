import 'package:flutter/material.dart';
import 'package:calendar/model/contenedor.dart';
import 'package:calendar/page/modal.dart';
import 'package:calendar/api/apiConection.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:calendar/model/doubleRow.dart';

class CalendarList extends StatefulWidget {
  CalendarList({Key key}) : super(key: key);

  @override
  CalendarListStage createState() => CalendarListStage();
}

class CalendarListStage extends State<CalendarList> {
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  var listadias = ['', 'L', 'M', 'X', 'J', 'V'];
  var listadatos;
  List listwrite = [];
  var write = <int>[];
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
    _listaContenedores = [];
    listaColumnas = <DoubleRow>[];
    staggeredTiles = <StaggeredTile>[];
    if (listadatos != null) {
      for (int i = 0; i < index; i++) {
        staggeredTiles.add(const StaggeredTile.count(1, 1));
        contenedores = <Contenedor>[];
        write = <int>[];
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
      write.add(0);
      contenedores.add(
          Contenedor(c, datos[0], int.parse(datos[2]), datos[3], datos[4]));
      if (datos[2] == "2") {
        staggeredTiles.add(const StaggeredTile.count(1, 2));
        listaColumnas.add(DoubleRow(i + 1, x));
      } else {
        staggeredTiles.add(const StaggeredTile.count(1, 1));
      }
    } else if (!contains) {
      write.add(0);
      contenedores.add(Contenedor(Theme.of(context).cardColor, "", 1, "", ""));
      staggeredTiles.add(const StaggeredTile.count(1, 1));
    }
    if (contains) {
      write.add(1);
    }
    setState(() {});
  }

  void addContainerRow() {
    _listaContenedores.add(contenedores);
    listwrite.add(write);
    setState(() {});
  }

  void actualizar() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: listContainer());
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
                        color: Theme.of(context).backgroundColor,
                        border: Border.all(
                            color: Theme.of(context).backgroundColor)),
                    child: Column(
                      children: [
                        Text(
                          listadias[i],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
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
                  new CircularProgressIndicator(
                    backgroundColor: Colors.pinkAccent,
                  ),
                  new Text(
                    "Loading",
                    style: TextStyle(fontSize: 20, color: Colors.pinkAccent),
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
                  child: Text(
                    listadatos[i]['H'],
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 20),
                  )))
        ]),
        if (i != listadatos.length - 1) ...{
          if (listadatos[i]['H'] == '11:40') ...{
            for (var x = 0; x < _listaContenedores[i].length; x++) ...{
              if (_listaContenedores[i][x].text == "") ...{
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _listaContenedores[i][x].text,
                      )),
                )
              } else ...{
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(
                        color: _listaContenedores[i][x].containerColor,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _listaContenedores[i][x].text,
                      )),
                )
              }
            }
          } else ...{
            for (var x = 0; x < _listaContenedores[i].length; x++) ...{
              if (_listaContenedores[i][x].text == "") ...{
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).cardColor,
                          border:
                              Border.all(color: Theme.of(context).canvasColor)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _listaContenedores[i][x].text,
                              style: TextStyle(
                                color: Colors.white,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              _listaContenedores[i][x].teacher,
                              style: TextStyle(
                                color: Colors.white,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              _listaContenedores[i][x].numberClass,
                              style: TextStyle(
                                color: Colors.white,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 3.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              ),
                            )
                          ])),
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: true,
                        pageBuilder: (BuildContext context, _, __) {
                          return Modal(
                            contenedor: _listaContenedores[i][x],
                            index: i,
                            index2: x,
                            day: listadias,
                            list: listadatos,
                            time: listadatos[i]['H'],
                            listwrite: listwrite,
                            listcontainer: _listaContenedores[i],
                          );
                        },
                      ),
                    );
                  },
                )
              } else ...{
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: _listaContenedores[i][x].containerColor,
                          border:
                              Border.all(color: Theme.of(context).canvasColor)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _listaContenedores[i][x].text,
                              style: TextStyle(
                                color: Colors.white,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              _listaContenedores[i][x].teacher,
                              style: TextStyle(
                                color: Colors.white,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              _listaContenedores[i][x].numberClass,
                              style: TextStyle(
                                color: Colors.white,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 3.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              ),
                            )
                          ])),
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: true,
                        pageBuilder: (BuildContext context, _, __) {
                          return Modal(
                            contenedor: _listaContenedores[i][x],
                            index: i,
                            index2: x,
                            day: listadias,
                            list: listadatos,
                            time: listadatos[i]['H'],
                            listwrite: listwrite,
                            listcontainer: _listaContenedores[i],
                          );
                        },
                      ),
                    );
                  },
                )
              }
            }
          }
        }
      }
    ];
  }
}
