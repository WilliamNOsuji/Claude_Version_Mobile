
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool errorUsername(BuildContext context,String username){

  if(username.trim() == ''){
    String message = "Username empty";
    showErrorMessage(context, message);
    return true;
  }

  if(username.trim().length < 3){
    String message = "Username needs to be more than 3 characters";
    showErrorMessage(context, message);
    return true;
  }
  return false;
}

bool errorSignUpPassword(BuildContext context,String password, String confirmPassowrd){

  if(password.trim() == '' || confirmPassowrd.trim() == ''){
    String message = "One of the password fields are emtpy";
    showErrorMessage(context, message);
    return true;
  }

  if(password.trim().length < 3){
    String message = "The password is too short";
    showErrorMessage(context, message);
    return true;
  }

  if(password.trim() != confirmPassowrd.trim()){
    String message = "Password and confirmed password arent the same";
    showErrorMessage(context, message);
    return true;
  }
  return false;
}

bool errorSignInPassword(BuildContext context,String password){

  if(password.trim() == ''){
    String message = "the password field is emtpy";
    showErrorMessage(context, message);
    return true;
  }

  if(password.trim().length < 3){
    String message = "The password is too short";
    showErrorMessage(context, message);
    return true;
  }

  return false;
}

bool error_matricule(BuildContext context,String matricule){


  if(matricule.trim() == ""){
    String message = "Maricule is empty";
    showErrorMessage(context, message);
    return true;
  }

  final numericRegex = RegExp(r'^\d+$');
  if(!numericRegex.hasMatch(matricule.trim())){
    String message = "Matricule needs to have only numeric digits";
    showErrorMessage(context, message);
    return true;
  }

  if(matricule.trim().length != 7){
    String message = "Matricule needs to be atleast 7 characters";
    showErrorMessage(context, message);
    return true;
  }

  if(matricule.trim().contains(",") || matricule.trim().contains(" ") || matricule.trim().contains(".") || matricule.trim().contains("-")){
    String message = "No special characters for the matricule";
    showErrorMessage(context, message);
    return true;
  }

  return false;
}

void showErrorMessage(BuildContext context, String message){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
  );
}
