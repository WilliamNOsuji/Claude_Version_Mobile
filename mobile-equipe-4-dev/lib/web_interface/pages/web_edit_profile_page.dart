import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobilelapincouvert/dto/auth.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_profile_page.dart';

import '../../services/api_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/drawerCart.dart';
import '../widgets/web_menu_drawer.dart';

class WebEditProfilePage extends StatefulWidget {
  final ProfileDTO profileDTO;
  const WebEditProfilePage({super.key, required this.profileDTO});

  @override
  State<WebEditProfilePage> createState() => _WebEditProfilePageState();
}

class _WebEditProfilePageState extends State<WebEditProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  XFile? _newProfileImage;
  bool isLoading = false;

  // Pick Image Function
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    // final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newProfileImage = pickedFile;
      });
    }
  }

  // Save Profile Function
  void _saveProfileInfo() async {
      FocusManager.instance.primaryFocus?.unfocus();
      try {
        setState(() {
          isLoading = true;
        });

        ProfileModificationDTO profileModificationDTO = ProfileModificationDTO(
            _firstNameController.text,
            _lastNameController.text,
            _passwordController.text,
            _oldPasswordController.text
        );
        File file = File(_newProfileImage!.path);

        // Call the API to update the profile
        ProfileDTO profileDTO = await ApiService().updateProfileWeb(profileModificationDTO, _newProfileImage, context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebProfilePage(profileDTO: profileDTO),
          ),
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile! Please try again.')),
        );
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: LeTiroir(),
      drawer: WebMenuDrawer(profileDTO: widget.profileDTO),
      appBar: WebCustomAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 730,
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    CircleAvatar(
                      radius: 120,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: _newProfileImage == null ?  NetworkImage(widget.profileDTO.imgUrl) : Image.network(_newProfileImage!.path).image,
                    ),
                    IconButton(
                        onPressed: _pickImage,
                        icon: SvgPicture.asset('assets/images/icon_picker_image.svg'))
                  ],
                ),
                SizedBox(height: 50),
                _buildSection("Mes informations", [
                  _buildField('Nom de famille', _lastNameController),
                  _buildField('Prénom', _firstNameController),
                ]),
                SizedBox(height: 50),
                _buildSection("Mot de passe", [
                  _buildField("Nouveau mot de passe", _passwordController),
                  _buildField("Ancien mot de passe", _oldPasswordController),
                ]),
                SizedBox(height: 50),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5FAD41),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  ),
                  onPressed: _saveProfileInfo,
                  child: Text(
                    'Enregistrer',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF738290))),
        SizedBox(height: 12),
        Divider(color: Color(0xFFD9D9D9)),
        ...children,
      ],
    );
  }

  Widget _buildField(String placeholder, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFEFEFEF), width: 2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: TextField(
          controller: controller,
          style: TextStyle(fontSize: 16, color: Color(0xFF738290)),
          decoration: InputDecoration(
            hintText: placeholder,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero, // Optional: removes extra padding
          ),
        ),
      ),
    );
  }
}
