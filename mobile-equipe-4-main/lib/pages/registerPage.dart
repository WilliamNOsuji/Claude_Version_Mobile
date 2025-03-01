import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/dto/authentificationDTOs.dart';
import 'package:mobilelapincouvert/gestion_erreurs.dart';
import 'package:mobilelapincouvert/libhttp.dart';
import '../generated/l10n.dart';
import '../widgets/custom_app_bar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

final TextEditingController username_controller = TextEditingController();
final TextEditingController password_controller = TextEditingController();
final TextEditingController matricule_controller = TextEditingController();
final TextEditingController confirmpassword_controller = TextEditingController();
class _RegisterPageState extends State<RegisterPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: CustomAppBar(title: 'Inscription', centerTitle: true, backgroundColor: Color(0xFF2E383A), titleColor: Colors.white),
        body: buildBody(),
        backgroundColor: Color(0xFF2AB24A)
    );
  }

  bool errorSignUp() {
    if (error_matricule(context, matricule_controller.text)||
        errorUsername(context, username_controller.text)  ||
        errorSignUpPassword(
            context, password_controller.text, confirmpassword_controller.text)){
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
                    //Text(S.of(context).registerPageTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
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
                      controller: username_controller,
                      cursorColor: _fontColor,
                      keyboardType: TextInputType.name,
                      maxLength: 16,
                      decoration:  InputDecoration(
                          hintText:S.of(context).labelUsername,
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
                    const SizedBox(height: 20),
                    TextField(
                      controller: confirmpassword_controller,
                      cursorColor: _fontColor,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          hintText: S.of(context).labelConfirmPassword ,
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
                            if(!errorSignUp()){
                              Navigator.pushNamed(context, '/homePage');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: _fontColor,
                              foregroundColor: Colors.white
                          ),
                          child: Text(S.of(context).buttonCreateAccont, style: TextStyle(color: Colors.white),),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pushNamed(context, '/loginPage');
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: _fontColor,
                            elevation: 0,
                          ),

                          child: Text(S.of(context).buttonConnexion),
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

  requestRegister()async{
    errorSignUp();
    RegisterDTO regDTO = RegisterDTO(
        username: username_controller.text,
        matricule: matricule_controller.text,
        email: '${matricule_controller.text}@cegepmontpetit.ca',
        password: password_controller.text,
        confirmPassword: confirmpassword_controller.text
    );

    String? response = await register(context, regDTO);

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.toString())));
  }
}
