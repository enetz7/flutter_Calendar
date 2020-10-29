import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:calendar/main.dart';

// ignore: must_be_immutable

class ApiConect extends StatefulWidget {
  ApiConect({Key key}) : super(key: key);

  

  @override
  ApiConection createState() => ApiConection();
}

class ApiConection extends State<ApiConect> {


  
  Future<List<dynamic>> loadCsvData() async {

    final response =
        await http.get('https://api.apispreadsheets.com/data/2351/');
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse['data'];
    }
    return null;
  }


  Future<http.Response> createCsv(List listadatos) async{
  http.get("https://api.apispreadsheets.com/data/2351/?query=deletefrom2351*");
  return http.post(
    'https://api.apispreadsheets.com/data/2351/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: convert.jsonEncode(<String, List>{
      'data': listadatos,
    }
    ),
  );
}
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  // This widget is the root of your application.
  
}