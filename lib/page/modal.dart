import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:calendar/model/contenedor.dart';
import 'package:calendar/api/apiConection.dart';
import 'package:calendar/main.dart';

class Modal extends StatefulWidget {
  Modal({Key key, this.contenedor, this.index, this.day, this.list})
      : super(key: key);

  Contenedor contenedor;
  int index;
  String day;
  List list;

  @override
  _Modal createState() => _Modal();
}

class _Modal extends State<Modal> {
  String dropdownValue = '1';

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

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Introducir clase"),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
                height: 54.0,
                padding: EdgeInsets.all(12.0),
                child: Text('Introducir nueva clase',
                    style: TextStyle(
                      fontSize: 20,
                    ))),
            TextField(
              onChanged: (value) => changeText(value),
            ),
            Row(
              children: [
                Text("Selecciona el numero de horas",
                    style: TextStyle(
                      fontSize: 18,
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.deepPurple, fontSize: 20),
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
                                widget.contenedor.containerColor = pickerColor;
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
                setState(() {
                  widget.list[widget.index][widget.day] =
                      widget.contenedor.text +
                          "|" +
                          widget.contenedor.containerColor.toString() +
                          "|" +
                          widget.contenedor.rowCount.toString();
                });
                ApiConection().createCsv(widget.list);
                main();
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
