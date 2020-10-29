import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:calendar/model/contenedor.dart';
import 'package:calendar/api/apiConection.dart';
class Modal extends StatefulWidget {
  Modal({Key key, this.contenedor,this.index,this.day,this.list}) : super(key: key);

  Contenedor contenedor;
  int index;
  String day;
  List list;

  @override
  _Modal createState() => _Modal();
}

class _Modal extends State<Modal> {
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void changeText(String value) {
    setState(() {
      widget.contenedor.note = value;
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
                  widget.list[widget.index][widget.day]=widget.contenedor.note+"|"+widget.contenedor.containerColor.toString();
                });
                ApiConection().createCsv(widget.list);
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
