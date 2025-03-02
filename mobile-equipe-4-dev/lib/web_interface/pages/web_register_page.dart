// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/gestion_erreurs.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_home_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_login_page.dart';
import 'package:mobilelapincouvert/web_interface/widgets/login_custom_app_bar.dart';
import '../../dto/auth.dart';
import '../../generated/l10n.dart';
import 'package:mobilelapincouvert/services/auth_service.dart';

bool isLoading = false;

class WebRegisterPage extends StatefulWidget {
  const WebRegisterPage({super.key});

  @override
  State<WebRegisterPage> createState() => _WebRegisterPageState();
}

final TextEditingController username_controller = TextEditingController();
final TextEditingController password_controller = TextEditingController();
final TextEditingController email_controller = TextEditingController();
final TextEditingController confirmpassword_controller =
    TextEditingController();
final TextEditingController firstname_controller = TextEditingController();
final TextEditingController lastname_controller = TextEditingController();

class _WebRegisterPageState extends State<WebRegisterPage> {
  final PageController _pageController = PageController();
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  int _currentPage = 0;


  void _nextPage() {
    if (_formKeys[_currentPage].currentState!.validate()) {
      if (_currentPage < _formKeys.length - 1) {
        setState(() {
          _currentPage++;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        FocusManager.instance.primaryFocus?.unfocus();
        requestRegister();
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WebLoginCustomAppBar(title: "2", centerTitle: false),
        body: buildBody(),
        backgroundColor: Colors.white);
  }

  Widget buildBody() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 140.0),
                    child: Center(
                      child: Stack(
                        children: [
                          Lottie.asset(
                            'assets/animations/loginAnimation.json', // Path to your Lottie JSON file
                            //height: 700,
                            width: 700,
                            fit: BoxFit.contain,
                          ),
                          Image.asset(
                            'assets/images/words_deliveryman_image.png',
                            width: 800,
                            fit: BoxFit.contain,
                          )
                        ],
                      ),
                    ),
                  )),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  margin: const EdgeInsets.only(bottom: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 450,
                        child: PageView(
                          controller: _pageController,
                          physics:
                              NeverScrollableScrollPhysics(), // Empêche le swipe manuel
                          children: [
                            _buildStep1(),
                            _buildStep2(),
                          ],
                        ),
                      ),
                      Container(
                        //padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_currentPage > 0)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: _previousPage,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: Text('Retour', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors().green(),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _nextPage,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: _currentPage == _formKeys.length - 1 ?
                                    isLoading ?
                                      SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                          color: Colors.white70,
                                        )
                                      ) :
                                    Text(
                                        S.of(context).labelRegister,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ) :
                                    Text('Suivant', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebLoginPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors().gray(),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 89, vertical: 9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
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
                          ),
                        ],
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

  requestRegister() async {
    setState(() {
      isLoading = !isLoading;
    });
    RegisterDTO regDTO = RegisterDTO(
        username_controller.text,
        firstname_controller.text,
        lastname_controller.text,
        '${username_controller.text}@lapincouvert.ca',
        password_controller.text,
        confirmpassword_controller.text);

    SigninSuccessDTO? response = await ApiService().register(context, regDTO);

    if (response != null) {
      await AuthService.saveToken(response.token);
      clearAllControllers();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebHomePage(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.clientName}est connecté!!!')));
    }

    setState(() {
      isLoading = !isLoading;
    });
  }

  Widget _buildStep1() {
    return Form(
      key: _formKeys[0],
      child: Column(
        children: [
          Text(
            S.of(context).registerPageTitle,
            style: TextStyle(
                fontSize: 28, fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.bold,
                color: AppColors().green(),),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40, // Circle size
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors().green(),
                  shape: BoxShape.circle, // Makes it a circle
                ),
                child: Center(
                    child: Text('1',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16))),
              ),
              Container(
                height: 1,
                width: 140,
                margin: EdgeInsets.symmetric(horizontal: 12),
                color: AppColors().gray(),
              ),
              Container(
                width: 30, // Circle size
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors().gray(),
                  shape: BoxShape.circle, // Makes it a circle
                ),
                child: Center(
                    child: Text(
                  '2',
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ],
          ),
          SizedBox(height: 45), // Add spacing between fields
          TextFormField(
            controller: username_controller,
            decoration: InputDecoration(
              labelText: S.of(context).labelUsername,
              labelStyle: TextStyle(color: AppColors().gray()),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors().green(), width: 1.0),
              ),
            ),
            validator: (value) =>
                errorUsername(context, username_controller.text),
          ),
          SizedBox(height: 28), // Add spacing between fields
          TextFormField(
            controller: firstname_controller,
            decoration: InputDecoration(
              labelText: S.of(context).labelFirstName,
              labelStyle: TextStyle(color: AppColors().gray()),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors().green(), width: 1.0),
              ),
            ),
            validator: (value) =>
                errorFirstName(context, firstname_controller.text),
          ),
          SizedBox(height: 28), // Add spacing between fields
          TextFormField(
            controller: lastname_controller,
            decoration: InputDecoration(
              labelText: S.of(context).labelLastName,
              labelStyle: TextStyle(color: AppColors().gray()),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors().green(), width: 1.0),
              ),
            ),
            validator: (value) =>
                errorLastName(context, lastname_controller.text),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _formKeys[1],
      child: Column(
        children: [
          Text(
            'Créer votre mot de passe',
            style: TextStyle(
              fontSize: 28, fontFamily: GoogleFonts.inter().fontFamily,
              fontWeight: FontWeight.bold,
              color: AppColors().green(),),
          ),

          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 30, // Circle size
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors().green(),
                  shape: BoxShape.circle, // Makes it a circle
                ),
                child: Center(
                    child: Text(
                  '1',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
              ),
              Container(
                height: 1,
                width: 140,
                margin: EdgeInsets.symmetric(horizontal: 12),
                color: AppColors().green(),
              ),
              Container(
                width: 40, // Circle size
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors().green(),
                  shape: BoxShape.circle, // Makes it a circle
                ),
                child: Center(
                    child: Text('2',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16))),
              ),
            ],
          ),
          SizedBox(height: 45),
          TextFormField(
            controller: password_controller,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: InputDecoration(
              labelText: S.of(context).labelPassword,
              labelStyle: TextStyle(color: AppColors().gray()),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors().green(), width: 1.0),
              ),
            ),
            validator: (value) => errorSignUpPassword(context,
                password_controller.text, confirmpassword_controller.text),
          ),
          SizedBox(height: 24), // Add spacing between fields
          TextFormField(
            controller: confirmpassword_controller,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: InputDecoration(
              labelText: S.of(context).labelConfirmPassword,
              labelStyle: TextStyle(color: AppColors().gray()),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors().green(), width: 1.0),
              ),
            ),
            validator: (value) => errorSignUpPassword(context,
                password_controller.text, confirmpassword_controller.text),
          ),
        ],
      ),
    );
  }

  void clearAllControllers() {
    username_controller.clear();
    password_controller.clear();
    email_controller.clear();
    confirmpassword_controller.clear();
    firstname_controller.clear();
    lastname_controller.clear();
  }
}
