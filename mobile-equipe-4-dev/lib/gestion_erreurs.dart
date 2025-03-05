import 'package:flutter/material.dart';

import 'generated/l10n.dart';

String? errorUsername(BuildContext context,String username){

  if(username.trim() == ''){
    String message = S.of(context).errorUsernameEmpty;
    return message;
  }

  if(username.trim().length < 3){
    String message = S.of(context).errorUsernameLength;
    return message;
  }

  return null;
}

String? errorNomComplet(BuildContext context,String nomComplet){

  if(nomComplet.trim() == ''){
    String message = 'Ce champs ne peut être vide';
    return message;
  }

  if(nomComplet.trim().length < 3){
    String message = 'Le nom saisi est trop court';
    return message;
  }

  return null;
}

String? errorLocal(BuildContext context,String local){

  if(local.trim() == ''){
    String message = 'Ce champs ne peut être vide';
    return message;
  }
  if(local.trim().length < 3){
    String message = 'Local invalide : minimum de 3 caractères';
    return message;
  }
  return null;
}

String? errorPhone(BuildContext context,String phoneNum){

  if(phoneNum.trim() == ''){
    String message = 'Ce champs ne peut être vide';
    return message;
  }
  if(phoneNum.trim().length != 10){
    String message = 'Le numéro saisi est invalide';
    return message;
  }
  return null;
}

String? errorSignUpPassword(BuildContext context,String password, String confirmPassowrd){

  if(password.trim() == '' || confirmPassowrd.trim() == ''){
    String message = S.of(context).errorRegisterPasswordsEmpty;
    return message;
  }

  if(password.trim().length < 6){
    String message = S.of(context).errorPasswordShort;
    return message;
  }

  if(password.length >= 40){
    String message = S.of(context).errorPasswordMaxLength;
    return message;
  }

  if(password.trim() != confirmPassowrd.trim()){
    String message = S.of(context).errorPasswordNotTheSame;
    return message;
  }

  return null;
}

String? errorSignInPassword(BuildContext context,String password){

  if(password.trim() == ''){
    String message = S.of(context).errorSignInPasswordEmpty;
    return message;
  }

  if(password.trim().length < 3){
    String message = S.of(context).errorSignInPasswordEmpty;
    return message;
  }

  if(password.length >= 40){
    String message = S.of(context).errorPasswordMaxLength;
    return message;
  }

  return null;
}

String? errorEmail(BuildContext context,String email){

  if(email.trim() == ""){
    String message = "Email field is empty";
    return message;
  }

  final RegExp regex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",);

  if(!regex.hasMatch(email.trim())){
    String message = "Email pattern failed. it has to be example@example.ca";
    return message;
  }
  return null;
}

String? errorFirstName(BuildContext context,String username){

  if(username.trim() == ''){
    String message = S.of(context).errorFirstName;
    return message;
  }

  if(username.trim().length < 2){
    String message = S.of(context).errorFirstNameLength;
    return message;
  }

  return null;
}

String? errorLastName(BuildContext context,String lastname){

  if(lastname.trim() == ''){
    String message = S.of(context).errorLastName;
    return message;
  }

  if(lastname.trim().length < 2){
    String message = S.of(context).errorLastNameLength;
    return message;
  }

  return null;
}

void showErrorMessage(BuildContext context, String message){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
  );
}
