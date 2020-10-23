
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Modal extends StatefulWidget {
  Modal({Key key}) : super(key: key);


 

  @override
    _Modal createState() => _Modal();
}


class _Modal extends State<Modal> {
  void changeColor(Color color) {
  setState(() => pickerColor = color);
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
               style: TextStyle(fontSize: 20,)
               )
            ),
            TextField(),
            Row(
            
            children:[
            Text("Selecciona el color del container     ",
            style: TextStyle(fontSize: 18),),
            RawMaterialButton(
              fillColor: pickerColor,
              padding: EdgeInsets.all(20),
              shape: CircleBorder(),
              onPressed:() {
                showDialog(
                  context: context,
                  child: AlertDialog(
                    title: const Text('Elige un color!'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged:changeColor,
                        showLabel: true,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: const Text('Listo'),
                        onPressed: () {
                          setState(() => currentColor = pickerColor);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
                }
                ),
            

            ]),
            RaisedButton(
            child: Text("Enviar"),
            onPressed: (){
              Navigator.of(context).pop();
            },
            )
          ],
        ),
      ),);
  }
}
