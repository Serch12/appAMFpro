import 'package:flutter/material.dart';
import 'package:splash_animated/src/models/news_models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;




class AfiliadosService with ChangeNotifier {
  final _urlBase = 'test-intranet.amfpro.mx';
  AfiliadosService(){
    getService();
  }

  getService() async{
    final url = Uri.http(_urlBase,'/api/datos-afiliados/nui/99722');
    final respuesta = await http.get(url);
    print(respuesta.body);
  }

  // final String _url = "http://test-intranet.amfpro.mx";


  // Future<List<Afiliados>> getAfiliados() async {
  //   var url = Uri.https( _url, '/api/datos-afiliados');
  //   final response = await http.get(url);
  //   print(response.body);
  // }

}