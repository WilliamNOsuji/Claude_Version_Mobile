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

class WebRegisterPage extends StatefulWidget {
  const WebRegisterPage({super.key});

  @override
  State<WebRegisterPage> createState() => _WebRegisterPageState();
}

class _WebRegisterPageState extends State<WebRegisterPage> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final TextEditingController username_controller = TextEditingController();
  final TextEditingController password_controller = TextEditingController();
  final TextEditingController email_controller = TextEditingController();
  final TextEditingController confirmpassword_controller = TextEditingController();
  final TextEditingController firstname_controller = TextEditingController();
  final TextEditingController lastname_controller = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();

    // Ajoute un écouteur pour mettre à jour l'UI en temps réel
    password_controller.addListener(() {
      setState(() {}); // Force le rebuild chaque fois que le texte change
    });

    confirmpassword_controller.addListener(() {
      setState(() {}); // Met à jour aussi quand l'utilisateur tape la confirmation
    });
  }

  @override
  void dispose() {
    username_controller.dispose();
    password_controller.dispose();
    email_controller.dispose();
    confirmpassword_controller.dispose();
    firstname_controller.dispose();
    lastname_controller.dispose();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

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
      backgroundColor: Colors.white,
    );
  }

  Widget buildBody() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1000;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/subtle_pattern_background.png'),
          repeat: ImageRepeat.repeat,
          opacity: 0.05,
        ),
      ),
      child: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: isSmallScreen ? screenWidth * 0.95 : screenWidth * 0.8,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: isSmallScreen
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16),
                  SizedBox(
                    height: 250,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Lottie.asset(
                          'assets/animations/loginAnimation.json',
                          width: 500,
                          fit: BoxFit.contain,
                        ),
                        Image.asset(
                          'assets/images/words_deliveryman_image.png',
                          width: 550,
                          fit: BoxFit.contain,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
                    elevation: 8,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: PageView(
                              controller: _pageController,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                _buildStep1(),
                                _buildStep2(),
                              ],
                            ),
                          ),
                          _buildNavButtons(),
                          SizedBox(height: 20),
                          _buildLoginButton(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 180.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Lottie.asset(
                            'assets/animations/loginAnimation.json',
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
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(30.0),
                      margin: const EdgeInsets.only(bottom: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 450,
                            child: PageView(
                              controller: _pageController,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                _buildStep1(),
                                _buildStep2(),
                              ],
                            ),
                          ),
                          _buildNavButtons(),
                          SizedBox(height: 20),
                          _buildLoginButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButtons() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
         mainAxisAlignment: (_currentPage > 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: [
          if (_currentPage > 0)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors().gray().withOpacity(0.3)),
                ),
              ),
              onPressed: _previousPage,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_rounded, size: 16, color: AppColors().gray()),
                    SizedBox(width: 12),
                    Text('Retour', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )
          else
            SizedBox(),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors().green(),
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: AppColors().green().withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _nextPage,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
              child: _currentPage == _formKeys.length - 1
                  ? isLoading
                  ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  )
              )
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    S.of(context).labelRegister,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.check_circle_outline, size: 18, color: Colors.white)
                ],
              )
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Suivant', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Divider(height: 32, thickness: 1, color: Colors.grey.shade200),
        SizedBox(height: 8),
        Text(
          'Vous avez déjà un compte?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: GoogleFonts.inter().fontFamily,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            // Add slide transition animation
            //await _animationController.reverse();
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
            elevation: 4,
            shadowColor: AppColors().gray().withOpacity(0.4),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            S.of(context).buttonConnexion,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: GoogleFonts.inter().fontFamily,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _formKeys[0],
      child: Column(
        children: [
          Text(
            S.of(context).registerPageTitle,
            style: TextStyle(
              fontSize: 24,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontWeight: FontWeight.bold,
              color: AppColors().green(),
            ),
          ),
          SizedBox(height: 40),

          // Progress indicator with step circles
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 500),
                builder: (context, double value, child) {
                  return Container(
                    width: 40 * value, // Animated size
                    height: 40 * value,
                    decoration: BoxDecoration(
                        color: AppColors().green(),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: AppColors().green().withOpacity(0.3),
                              blurRadius: 8 * value,
                              spreadRadius: 1 * value
                          )
                        ]
                    ),
                    child: Center(
                      child: Text('1',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          )
                      ),
                    ),
                  );
                },
              ),
              Container(
                height: 2,
                width: 140,
                margin: EdgeInsets.symmetric(horizontal: 12),
                color: AppColors().gray(),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors().gray(),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('2', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),

          SizedBox(height: 40),

          // Username field
          TextFormField(
            controller: username_controller,
            decoration: InputDecoration(
              labelText: S.of(context).labelUsername,
              labelStyle: TextStyle(color: AppColors().gray()),
              prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors().gray()),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors().green(), width: 1.5),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            ),
            validator: (value) => errorUsername(context, username_controller.text),
          ),

          SizedBox(height: 24),

          // First name field
          TextFormField(
            controller: firstname_controller,
            decoration: InputDecoration(
              labelText: S.of(context).labelFirstName,
              labelStyle: TextStyle(color: AppColors().gray()),
              prefixIcon: Icon(Icons.badge_outlined, color: AppColors().gray()),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors().green(), width: 1.5),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            ),
            validator: (value) => errorFirstName(context, firstname_controller.text),
          ),

          SizedBox(height: 24),

          // Last name field
          TextFormField(
            controller: lastname_controller,
            decoration: InputDecoration(
              labelText: S.of(context).labelLastName,
              labelStyle: TextStyle(color: AppColors().gray()),
              prefixIcon: Icon(Icons.person_pin_outlined, color: AppColors().gray()),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors().green(), width: 1.5),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            ),
            validator: (value) => errorLastName(context, lastname_controller.text),
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
              fontSize: 28,
              fontFamily: GoogleFonts.inter().fontFamily,
              fontWeight: FontWeight.bold,
              color: AppColors().green(),
            ),
          ),

          SizedBox(height: 40),

          // Progress indicator with step circles
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors().green(),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('1', style: TextStyle(color: Colors.white)),
                ),
              ),
              Container(
                height: 2,
                width: 140,
                margin: EdgeInsets.symmetric(horizontal: 12),
                color: AppColors().green(),
              ),
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 500),
                builder: (context, double value, child) {
                  return Container(
                    width: 40 * value, // Animated size
                    height: 40 * value,
                    decoration: BoxDecoration(
                        color: AppColors().green(),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: AppColors().green().withOpacity(0.3),
                              blurRadius: 8 * value,
                              spreadRadius: 1 * value
                          )
                        ]
                    ),
                    child: Center(
                      child: Text('2',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          )
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          SizedBox(height: 40),

          // Password field
          TextFormField(
            controller: password_controller,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: S.of(context).labelPassword,
              labelStyle: TextStyle(color: AppColors().gray()),
              prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors().gray()),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors().gray(),
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors().green(), width: 1.5),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            ),
            validator: (value) => errorSignUpPassword(context,
                password_controller.text, confirmpassword_controller.text),
          ),

          SizedBox(height: 24),

          // Confirm password field
          TextFormField(
            controller: confirmpassword_controller,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: S.of(context).labelConfirmPassword,
              labelStyle: TextStyle(color: AppColors().gray()),
              prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors().gray()),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors().gray(),
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors().green(), width: 1.5),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            ),
            validator: (value) => errorSignUpPassword(context,
                password_controller.text, confirmpassword_controller.text),
          ),

          SizedBox(height: 16),

          // Password requirements
          AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(milliseconds: 500),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exigences de sécurité:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors().gray(),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        password_controller.text.length >= 8
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        size: 16,
                        color: password_controller.text.length >= 8
                            ? AppColors().green()
                            : Colors.grey,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Minimum 8 caractères',
                        style: TextStyle(
                          color: password_controller.text.length >= 8
                              ? AppColors().green()
                              : Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        password_controller.text == confirmpassword_controller.text &&
                            password_controller.text.isNotEmpty
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        size: 16,
                        color: password_controller.text == confirmpassword_controller.text &&
                            password_controller.text.isNotEmpty
                            ? AppColors().green()
                            : Colors.grey,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Les mots de passe correspondent',
                        style: TextStyle(
                          color: password_controller.text == confirmpassword_controller.text &&
                              password_controller.text.isNotEmpty
                              ? AppColors().green()
                              : Colors.grey,
                          fontSize: 14,
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

  void requestRegister() async {
    setState(() {
      isLoading = true;
    });

    RegisterDTO regDTO = RegisterDTO(
        username_controller.text,
        firstname_controller.text,
        lastname_controller.text,
        '${username_controller.text}@lapincouvert.ca',
        password_controller.text,
        confirmpassword_controller.text);

    try {
      SigninSuccessDTO? response = await ApiService().register(context, regDTO);

      if (response != null) {
        await AuthService.saveToken(response.token);
        clearAllControllers();

        // Success animation before navigation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text('${response.clientName} est connecté!'),
              ],
            ),
            backgroundColor: AppColors().green(),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Animate out before pushing to home page
        await _animationController.reverse();

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => WebHomePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = Offset(0.0, 0.3);
              var end = Offset.zero;
              var curve = Curves.easeOut;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            transitionDuration: Duration(milliseconds: 500),
          ),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),
              Text('Une erreur est survenue. Veuillez réessayer.'),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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