import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/dto/auth.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:mobilelapincouvert/pages/authenticationPages/registerPage.dart';
import 'package:mobilelapincouvert/services/auth_service.dart';

import '../../generated/l10n.dart';
import '../../gestion_erreurs.dart';
import '../../services/api_service.dart';
import '../../web_interface/pages/web_login_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
final TextEditingController username_controller = TextEditingController();
final TextEditingController password_controller = TextEditingController();
bool isLoading = false;

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> loginFormkey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    username_controller.text = '';
    password_controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: kIsWeb ? WebLoginPage() : buildBody(),
      backgroundColor: Colors.white,
    );
  }

  Widget buildBody() {
    Color _fontColor = Color(0xFF2E383A);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.40,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                  'assets/animations/rabbit_animation.json', // Path to your Lottie JSON file
                  width: 160, // Adjust size as needed
                  height: 160,
                  fit: BoxFit.cover,
                  ),

                  Text(
                    'Lapin Couvert',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF5FAD41),
                      fontSize: 40,
                      fontFamily: GoogleFonts.satisfy().fontFamily,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  //SizedBox(height: 24),

                ],
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(S.of(context).loginPageTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: AppColors().green()),),
                  SizedBox(height: 48),
                  // Form
                  Form(
                    key: loginFormkey,
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
                        SizedBox(height: 16), // Add spacing between fields
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
                  SizedBox(height: 24), // Add spacing between form and buttons
                  // Login Button
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!isLoading) {
                              if (loginFormkey.currentState!.validate()) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                setState(() {
                                  isLoading = true;
                                });
                                SigninDTO signinDTO = SigninDTO(username_controller.text.toString(), password_controller.text.toString());
                                SigninSuccessDTO? result = await ApiService().login(context, signinDTO);
                                if (result != null) {
                                  await AuthService.saveToken(result.token);
                                  Navigator.pushReplacementNamed(context, '/homePage', arguments: result.token);
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
                            padding: const EdgeInsets.symmetric(horizontal: 110, vertical: 9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(color: Colors.white70),
                          )
                              : Text(
                            S.of(context).buttonConnexion,
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
                    ],
                  ),
                  SizedBox(height: 16), // Add spacing between buttons
                  // Create Account Button
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors().gray(),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 89, vertical: 9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            S.of(context).crerUnCompte,
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
