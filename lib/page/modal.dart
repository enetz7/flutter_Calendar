import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:calendar/model/contenedor.dart';
import 'package:calendar/api/apiConection.dart';
import 'package:calendar/main.dart';

class Modal extends StatefulWidget {
  Modal(
      {Key key,
      this.contenedor,
      this.index,
      this.index2,
      this.day,
      this.list,
      this.time,
      this.listwrite,
      this.listcontainer})
      : super(key: key);

  Contenedor contenedor;
  int index;
  int index2;
  List day;
  List list;
  String time;
  List listcontainer;
  List listwrite;
  @override
  _Modal createState() => _Modal();
}

class _Modal extends State<Modal> {
  String dropdownValue = '1';
  int contador = 0;
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void changeText(String value) {
    setState(() {
      widget.contenedor.text = value;
    });
  }

  void changeRowCount(String rowCount) {
    setState(() {
      widget.contenedor.rowCount = int.parse(rowCount);
    });
  }

  void changeClass(String value) {
    setState(() {
      widget.contenedor.numberClass = value;
    });
  }

  void changeTeacher(String value) {
    setState(() {
      widget.contenedor.teacher = value;
    });
  }

  void addToList() {
    contador = 0;
    for (int x = 0; x < widget.listcontainer.length; x++) {
      if (widget.listwrite[widget.index][x] == 1) {
        contador++;
        setState(() {});
      }
      if (widget.listwrite[widget.index][x] == 1 && widget.index2 == x) {
        widget.list[widget.index][widget.day[contador + x + 1]] =
            widget.contenedor.text +
                "|" +
                widget.contenedor.containerColor.toString() +
                "|" +
                widget.contenedor.rowCount.toString() +
                "|" +
                widget.contenedor.teacher +
                "|" +
                widget.contenedor.numberClass;
      } else if (widget.index2 == x) {
        if (widget.listwrite[widget.index][x + 1] == 1) {
          widget.list[widget.index][widget.day[contador + x + 2]] =
              widget.contenedor.text +
                  "|" +
                  widget.contenedor.containerColor.toString() +
                  "|" +
                  widget.contenedor.rowCount.toString() +
                  "|" +
                  widget.contenedor.teacher +
                  "|" +
                  widget.contenedor.numberClass;
        } else {
          widget.list[widget.index][widget.day[widget.index2 + 1]] =
              widget.contenedor.text +
                  "|" +
                  widget.contenedor.containerColor.toString() +
                  "|" +
                  widget.contenedor.rowCount.toString() +
                  "|" +
                  widget.contenedor.teacher +
                  "|" +
                  widget.contenedor.numberClass;
        }
      }
    }
    setState(() {});
  }

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text("Introducir clase"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(12.0),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Container(
                    height: 54.0,
                    padding: EdgeInsets.all(12.0),
                    child: Text('Introducir nueva asignatura',
                        style: TextStyle(
                          fontSize: 20,
                        ))),
                TextField(
                  onChanged: (value) => changeText(value),
                ),
                Container(
                    height: 54.0,
                    padding: EdgeInsets.all(12.0),
                    child: Text('Introducir profesor de la asignatura',
                        style: TextStyle(
                          fontSize: 20,
                        ))),
                TextField(
                  onChanged: (value) => changeTeacher(value),
                ),
                Container(
                    height: 54.0,
                    padding: EdgeInsets.all(12.0),
                    child: Text('Introducir numero de aula',
                        style: TextStyle(
                          fontSize: 20,
                        ))),
                TextField(
                  onChanged: (value) => changeClass(value),
                ),
                Row(
                  children: [
                    Text("Selecciona el numero de horas",
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    if (widget.time == '10:45' || widget.time == '13:55') ...{
                      Padding(
                        padding: EdgeInsets.only(left: 50),
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style:
                              TextStyle(color: Colors.deepPurple, fontSize: 20),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                            changeRowCount(newValue);
                          },
                          items: <String>['1']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    } else ...{
                      Padding(
                        padding: EdgeInsets.only(left: 50),
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          dropdownColor: Theme.of(context).cardColor,
                          focusColor: Colors.white,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style:
                              TextStyle(color: Colors.deepPurple, fontSize: 20),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                            changeRowCount(newValue);
                          },
                          items: <String>['1', '2']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    }
                  ],
                ),
                Row(children: [
                  Text(
                    "Selecciona el color del container   ",
                    style: TextStyle(fontSize: 18),
                  ),
                  RawMaterialButton(
                      fillColor: pickerColor,
                      padding: EdgeInsets.all(20),
                      shape: CircleBorder(),
                      onPressed: () {
                        showDialog(
                          context: context,
                          child: AlertDialog(
                            title: const Text('Elige un color!'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: pickerColor,
                                onColorChanged: changeColor,
                                showLabel: true,
                                pickerAreaHeightPercent: 0.8,
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: const Text('Listo'),
                                onPressed: () {
                                  setState(() => currentColor = pickerColor);
                                  setState(() {
                                    widget.contenedor.containerColor =
                                        pickerColor;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                ]),
                RaisedButton(
                  child: Text("Enviar"),
                  onPressed: () {
                    addToList();
                    ApiConection().createCsv(widget.list);
                    main();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        ));
  }
}
