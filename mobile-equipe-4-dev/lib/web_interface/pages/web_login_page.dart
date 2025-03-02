import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/dto/auth.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:mobilelapincouvert/pages/HomePage.dart';
import 'package:mobilelapincouvert/pages/authenticationPages/registerPage.dart';
import 'package:mobilelapincouvert/services/auth_service.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_home_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_register_page.dart';
import 'package:mobilelapincouvert/web_interface/widgets/custom_app_bar.dart';
import 'package:mobilelapincouvert/web_interface/widgets/login_custom_app_bar.dart';

import '../../generated/l10n.dart';
import '../../gestion_erreurs.dart';
import '../../services/api_service.dart';
import '../../web_interface/pages/web_login_page.dart';

class WebLoginPage extends StatefulWidget {
  const WebLoginPage({super.key});

  @override
  State<WebLoginPage> createState() => _WebLoginPageState();
}

final TextEditingController username_controller = TextEditingController();
final TextEditingController password_controller = TextEditingController();
GlobalKey<FormState> formkey = GlobalKey<FormState>();
bool isLoading = false;

class _WebLoginPageState extends State<WebLoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WebLoginCustomAppBar(title: "", centerTitle:false),
      body: buildBody(),
      // backgroundColor: Color(0xFF2AB24A)
      backgroundColor: Colors.white,
    );
  }

  Widget buildBody() {
    Color _fontColor = Color(0xFF2E383A);
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:140.0),
                    child: Center(
                      child: Stack(
                        children: [
                          Lottie.asset(
                            'assets/animations/loginAnimation.json', // Path to your Lottie JSON file
                            //height: 700,
                            width: 700,
                            fit: BoxFit.contain,
                          ),
                          Image.asset('assets/images/words_deliveryman_image.png', width: 800,fit: BoxFit.contain,)
                        ],
                      ),
                    ),
                  )
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Se Connecter', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontFamily: GoogleFonts.inter().fontFamily, fontWeight: FontWeight.bold,color: AppColors().green()),),
                      SizedBox(height: 90),
                      // Form
                      Form(
                        key: formkey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: username_controller,
                              cursorColor: _fontColor,
                              validator: (value) => errorUsername(context, username_controller.text),
                              maxLength: 16,
                              decoration: InputDecoration(
                                hintText: S.of(context).labelUsername,
                                hintStyle: TextStyle(color: AppColors().gray()),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1.0
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1.0
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors().green(),
                                      width: 1.0
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30), // Add spacing between fields
                            TextFormField(
                              controller: password_controller,
                              cursorColor: _fontColor,
                              validator: (value) => errorSignInPassword(context, password_controller.text),
                              obscureText: true,
                              maxLength: 16,
                              decoration: InputDecoration(
                                hintText: S.of(context).labelPassword,
                                hintStyle: TextStyle(color: AppColors().gray()),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1.0
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1.0
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors().green(),
                                      width: 1.0
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 80), // Add spacing between form and buttons
                      // Login Button
                      ElevatedButton(
                        onPressed: () async {
                          if (!isLoading) {
                            if (formkey.currentState!.validate()) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                isLoading = true;
                              });
                              SigninDTO signinDTO = SigninDTO(username_controller.text.toString(), password_controller.text.toString());
                              SigninSuccessDTO? result = await ApiService().login(context, signinDTO);
                              if (result != null) {
                                await AuthService.saveToken(result.token);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors().green(),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: isLoading
                              ? SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(color: Colors.white70),
                          )
                              : Text(
                            'Connexion',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30), // Add spacing between buttons
                      // Create Account Button
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors().gray(),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Créer un compte',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 80,),
                      Text(
                        'Bon appétit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors().green(),
                          fontSize: 30,
                          fontFamily: GoogleFonts.satisfy().fontFamily,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
