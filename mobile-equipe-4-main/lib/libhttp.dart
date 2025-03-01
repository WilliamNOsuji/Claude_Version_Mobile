
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/dto/authentificationDTOs.dart';

const baseUrl = "http://10.0.2.2:5180/api/";

Dio getDio(){
  Dio dio = Dio();
  return dio;
}

Future<String> testApi(BuildContext context, String name) async {
  try{
    Dio dio = Dio();
    //final response = await dio.get("${baseUrl}Products/Test/$name");
    final response = await dio.get("https://api-lapincouvert-hke0a0a6cjg5c3gh.canadacentral-01.azurewebsites.net/api/Products/Test/$name");
    print("IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII"+response.toString());
    return response.data;
  } on DioException catch(e){
    String message = e.response!.data;
    if(e.type == DioExceptionType.connectionError){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Problème de connexion")));
      return '';
    }

    if (e.response!.statusCode ==404){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("ERREUR 404! Inscrivez une valeur valide")));
      return '';
    }
    return '';

  }
}

Future<String?> register(BuildContext context, RegisterDTO registerDTO) async {
  try{
    final response = await getDio().post(
      '${baseUrl}Account/Register',
      data: registerDTO.toJson(), // Convert the DTO to JSON for the request body
      options: Options(
        headers: {
          'Content-Type': 'application/json', // Explicit Content-Type
        },
      ),
    );
    return response.data;
  } on DioException catch(e){
    String message = e.response!.data;
    if (e.response!.statusCode ==404){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("ERREUR 404! Inscrivez une valeur valide")));

    }
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("QQQQQQQQQQQQQQQQQ"+message)));

  }
  return null;
}