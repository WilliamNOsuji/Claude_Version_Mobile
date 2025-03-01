import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../gestion_erreurs.dart';
import '../widgets/custom_app_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final TextEditingController matricule_controller = TextEditingController();
final TextEditingController password_controller = TextEditingController();
class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: CustomAppBar(title: 'Accueil', centerTitle: true, backgroundColor: Color(0xFF2E383A), titleColor: Colors.white),
      body: buildBody(),
      backgroundColor: Color(0xFF2AB24A)
    );
  }

  bool errorSignIn() {
    if (error_matricule(context, matricule_controller.text)||
        errorSignInPassword(context, password_controller.text)){
      return true;
    }
    return false;
  }

  Widget buildBody(){
    Color _fontColor = Color(0xFF2E383A);
    return SingleChildScrollView(
      child: Center(
          child: Column(
            children: [
              Image.asset('assets/images/adept_logo.jpg'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: Column(
                  children: [
                    //Text(S.of(context).connexionPageTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                    const SizedBox(height: 24),
                    TextField(
                      controller: matricule_controller,
                      cursorColor: _fontColor,
                      keyboardType: TextInputType.number,
                      maxLength: 7,
                      decoration:  InputDecoration(
                          hintText:S.of(context).labelMatricule,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: _fontColor, // Change border color here
                                width: 2.0, // Border width
                              )
                          )
                      ),
                    ),
                    TextField(
                      controller: password_controller,
                      cursorColor: _fontColor,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          hintText: S.of(context).labelPassword ,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: _fontColor, // Change border color here
                                width: 2.0, // Border width
                              )
                          )
                      ),
                    ),
                    const SizedBox(height: 48),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if(!errorSignIn()){
                              Navigator.pushNamed(context, '/homePage');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: _fontColor,
                              foregroundColor: Colors.white
                          ),
                          child: Text(S.of(context).buttonConnexion, style: TextStyle(color: Colors.white),),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pushNamed(context, '/registerPage');
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: _fontColor,
                              elevation: 0,
                          ),
                          child: Text(S.of(context).buttonCreateAccont),
                        ),

                      ],
                    )

                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}
