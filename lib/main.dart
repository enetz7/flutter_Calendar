import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _loadCsvData(),
        builder: (_, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: snapshot.data
                    .map(
                      (row) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // Name
                            Text(row[0]),
                            //Coach
                            Text(row[1]),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          }

          return Center(
            child: Text('no data found !!!'),
          );
        },
      ),
    );
  }

/*
  Future<String> readCounter() async {
    try {
      final file = await _localFile;

      String contents = await file.readAsString();
      print(contents);
      return contents;
    } catch (e) {
      // If we encounter an error, return 0
      return 'hola';
    }
  }
*/
  /*Stream<List<dynamic>> devolverLista() {
    final File file = new File('C:/Calendario.xlsx');
    Stream<List> inputStream = file.openRead();
    return inputStream;
  }*/

  Widget crearTabla() {
    final File file = new File('C:/Users/enetz/Desktop/Calendario.xlsx');
    //Stream<List> inputStream = file.openRead();
    //String content = file.readAsStringSync();

    DataTable tabla;
    //inputStream
    //    .transform(utf8.decoder) // Decode bytes to UTF-8.
    //    .transform(new LineSplitter()) // Convert stream to individual lines.
    //    .listen((String line) {
    while (false) {
      tabla = DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'Lunes',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Martes',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Role',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
        rows: const <DataRow>[
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Sarah')),
              DataCell(Text('19')),
              DataCell(Text('Student')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Janine')),
              DataCell(Text('43')),
              DataCell(Text('Professor')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('William')),
              DataCell(Text('27')),
              DataCell(Text('Associate Professor')),
            ],
          ),
        ],
      );
      //}
    }
    //);
    return tabla;
  }

  // load csv as string and transform to List<List<dynamic>>
  /*
  [
    ['Name', 'Coach', 'Players'],
    ['Name1', 'Coach1', '5'],
    etc
  ]
  */
  Future<List<List<dynamic>>> _loadCsvData() async {
    final file = new File('./csv/Calendario.csv');
    Stream<List> inputStream = file.openRead();
    inputStream
        .transform(utf8.decoder) // Decode bytes to UTF-8.
        .transform(new LineSplitter()) // Convert stream to individual lines.
        .listen((String line) {
      // Process results.

      List row = line.split(','); // split by comma

      String id = row[0];
      String symbol = row[1];
      String open = row[2];
      String low = row[3];
      String high = row[4];
      String close = row[5];
      String volume = row[6];
      String exchange = row[7];
      String timestamp = row[8];
      String date = row[9];

      print('$id, $symbol, $open');
    });
    final file2 = new File('./csv/Calendario.csv').openRead();
    return await file2
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
  }
}
