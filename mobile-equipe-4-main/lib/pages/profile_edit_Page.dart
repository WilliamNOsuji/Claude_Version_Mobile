import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/widgets/bottom_nav.dart';
import '../generated/l10n.dart';
import '../gestion_erreurs.dart';
import '../widgets/custom_app_bar.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final TextEditingController _usernameController = TextEditingController(text: 'Lapin');
  final TextEditingController _passwordController = TextEditingController(text: 'password123');

  final String _matricule = '1234567';

  bool _isObscure = true;

  bool errorSignIn() {
    if (errorUsername(context, _usernameController.text)  ||
        errorSignInPassword(context, _passwordController.text)){
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Modifier mon profil', centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        child: Column(
          children: [
            // Line between page and AppBar
            Divider(
              color: Color(0xFFCFCFCF),
              indent: 20,
              endIndent: 20,
            ),

            // Space
            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              width: 220,
              child: Stack(
                children: [

                  // Picture
                  CircleAvatar(
                    radius: 150,
                    backgroundColor: Colors.grey.shade300,
                    child: Image.asset('assets/images/profile_picture.webp'),
                  ),

                  // Change picture button
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        //TODO: Search image to update it
                      },
                      child: CircleAvatar(
                        backgroundColor: Color(0xFF159315),
                        radius: 22,
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Space
            const SizedBox(height: 30),

            // Profile infos
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // Matricule (Not modifiable)
                  _buildLabel(S.of(context).labelIDNumber),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                      ),
                      hintText: _matricule,
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      border: const UnderlineInputBorder(),
                    ),
                  ),

                  // Space
                  const SizedBox(height: 24),

                  // Username
                  _buildLabel(S.of(context).labelUsername),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                      ),
                      hintText: S.of(context).hintUsernameTF,
                      border: UnderlineInputBorder(),
                    ),
                  ),

                  // Space
                  const SizedBox(height: 24),

                  // Password
                  _buildLabel(S.of(context).labelPassword),
                  TextField(
                    readOnly: true,
                    controller: _passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                      ),
                      hintText: S.of(context).hintPasswordTF,
                      border: const UnderlineInputBorder(),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              _isObscure ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //Space
            const SizedBox(height: 40),

            // Save profile button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF159315),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if(!errorSignIn()){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(S.of(context).modifyProfileSnackBar),
                      ),
                    );
                  }
                },
                child: Text(
                  S.of(context).saveChangeButton,
                  style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF)),
                ),
              ),
            ),

            // Space
            const SizedBox(height: 20),

            // Cancel button
            TextButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:  Text(
                S.of(context).cancelButton,
                style: TextStyle(fontSize: 16, color: Color(0xFF880303)),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Powered by ',
                      style:  TextStyle(fontSize: 10)
                  ),
                  Image.asset(
                    'assets/images/adeptinfo_badge.png',
                    height: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: navigationBar(context, 2, setState),
    );
  }

  // Form labels widget
  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black54,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

}