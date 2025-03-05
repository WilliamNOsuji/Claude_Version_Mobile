import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/dto/auth.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:mobilelapincouvert/pages/HomePage.dart';
import 'package:mobilelapincouvert/services/auth_service.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_register_page.dart';
import 'package:mobilelapincouvert/web_interface/widgets/login_custom_app_bar.dart';
import '../../generated/l10n.dart';
import '../../gestion_erreurs.dart';
import '../../services/api_service.dart';

class WebLoginPage extends StatefulWidget {
  const WebLoginPage({super.key});

  @override
  State<WebLoginPage> createState() => _WebLoginPageState();
}

class _WebLoginPageState extends State<WebLoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController username_controller = TextEditingController();
  final TextEditingController password_controller = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscurePassword = true;

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
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
  }
  @override
  void dispose() {
    username_controller.dispose();
    password_controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WebLoginCustomAppBar(title: "", centerTitle: false),
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: SizedBox(
              width: isSmallScreen ? screenWidth * 0.95 : screenWidth * 0.8,
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
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: _buildLoginForm(),
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
                          child: _buildLoginForm(),
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

  Widget _buildLoginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Se Connecter',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.bold,
            color: AppColors().green(),
          ),
        ),
        SizedBox(height: 40),

        // Form
        Form(
          key: formkey,
          child: Column(
            children: [
              // Username field with animation
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut,
                builder: (context, double value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: TextFormField(
                  controller: username_controller,
                  cursorColor: AppColors().black(),
                  validator: (value) => errorUsername(context, username_controller.text),
                  maxLength: 16,
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
                ),
              ),

              SizedBox(height: 24),

              // Password field with animation
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut,
                //delay: Duration(milliseconds: 100),
                builder: (context, double value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: TextFormField(
                  controller: password_controller,
                  cursorColor: AppColors().black(),
                  validator: (value) => errorSignInPassword(context, password_controller.text),
                  obscureText: _obscurePassword,
                  maxLength: 16,
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
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 40),

        // Login Button with animation
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
          //delay: Duration(milliseconds: 200),
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: ElevatedButton(
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

                    // Success animation before navigation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 10),
                            Text('${result.clientName} est connecté!'),
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
                        pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
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
                  setState(() {
                    isLoading = false;
                  });
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors().green(),
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: AppColors().green().withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: isLoading
                ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
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

        SizedBox(height: 20),

        // Divider and Create Account section
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
          //delay: Duration(milliseconds: 300),
          builder: (context, double value, child) {
            return Opacity(
              opacity: value,
              child: child,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Divider(height: 32, thickness: 1, color: Colors.grey.shade200),
              SizedBox(height: 8),
              Text(
                'Vous n\'avez pas encore de compte?',
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
                 // await _animationController.reverse();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebRegisterPage(),
                    ),
                  );

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors().gray(),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: AppColors().gray().withOpacity(0.4),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
            ],
          ),
        ),

        SizedBox(height: 50),

        // Footer text with animation
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
          //delay: Duration(milliseconds: 400),
          builder: (context, double value, child) {
            return Opacity(
              opacity: value,
              child: child,
            );
          },
          child: Text(
            'Bon appétit',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors().green(),
              fontSize: 30,
              fontFamily: GoogleFonts.satisfy().fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}