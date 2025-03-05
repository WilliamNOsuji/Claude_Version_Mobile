import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mobilelapincouvert/pages/clientProfilePages/profilePage.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/widgets/navbarWidgets/navBarDelivery.dart';
import 'package:mobilelapincouvert/widgets/navbarWidgets/navBarNotDelivery.dart';
import '../../dto/auth.dart';
import '../../generated/l10n.dart';
import '../../widgets/custom_app_bar.dart';

class ProfileEditPage extends StatefulWidget {
  final ProfileDTO profile;

  const ProfileEditPage({super.key, required this.profile});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  //static const String baseUrl = "http://10.0.2.2:5180";
  static const String baseUrl= "api-lapincouvert-hke0a0a6cjg5c3gh.canadacentral-01.azurewebsites.net";
  bool _isObscure = true;
  bool isLoading = false;
  bool showPaswordForm = false;
  File? _newProfileImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstNameController.text = widget.profile.firstName;
    _lastNameController.text = widget.profile.lastName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Modifier mon profil', centerTitle: true),
      body: buildBody(),
      bottomNavigationBar: ApiService.isDelivery
          ? navBarFloatingYesDelivery(context, 4, setState)
          : navBarFloatingNoDelivery(context, 3, setState),
    );
  }

  Widget buildBody(){
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SizedBox(height: 8),
          _buildProfilePicture(),
          const SizedBox(height: 30),
          // Profile Edit Form
          Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_firstNameController,S.of(context).labelFirstName),
                    _buildTextField(_lastNameController, S.of(context).labelLastName),
                  ],
                ),
              ),
              showPaswordForm ? Column(
                children: [
                  _buildPasswordField(_passwordController, S.of(context).labelNewPassord),
                  _buildPasswordField(_oldPasswordController, S.of(context).labelOldPassord),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _passwordController.clear();
                        _oldPasswordController.clear();
                        showPaswordForm = !showPaswordForm;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.cancel, color: Colors.grey),
                        SizedBox(width: 6),
                        Text("Ne pas changer de mot de passe", style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                ],
              ) :
              Padding(
                padding: const EdgeInsets.only(top:24.0),
                child: ElevatedButton(
                    onPressed: (){
                      setState(() {
                        showPaswordForm = !showPaswordForm;
                      });
                    },
                    child: Text(S.of(context).changePassword),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                ),

              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF159315),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _saveProfileInfo,
                  child: isLoading ? SizedBox(height: 28,width: 28, child: CircularProgressIndicator(color: Colors.white)) :
                  Text(
                    S.of(context).saveChangeButton,
                    style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // Profile Picture Widget
  Widget _buildProfilePicture() {
    return SizedBox(
      height: 220,
      width: 220,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 150,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: _newProfileImage == null ?  NetworkImage(widget.profile.imgUrl) : FileImage(_newProfileImage!),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: _pickImage, // Pick image from gallery
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
    );
  }

  // Text Input Field Widget
  Widget _buildTextField(TextEditingController controller,String label,) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      maxLength: 16,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          controller.clear();
          return '${S.of(context).changePassword} $label';
        }
        return null;
      },
    );
  }

  // Password Field Widget
  Widget _buildPasswordField(TextEditingController controller, String label,) {

    return TextFormField(
      controller: controller,
      obscureText: _isObscure,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '${S.of(context).enterYour} $label';
        }
        return null;
      },
    );
  }

  // Save Profile Function
  void _saveProfileInfo() async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusManager.instance.primaryFocus?.unfocus();
      try {

        setState(() {
          isLoading = true;
        });

        String firstName = '';
        String lastName = '';

        if(_firstNameController.text != widget.profile.firstName){
          firstName = _firstNameController.text;
        }
        if(_lastNameController.text != widget.profile.lastName){
          lastName = _lastNameController.text;
        }
        ProfileModificationDTO profileData = ProfileModificationDTO(
            firstName,
            lastName,
            _passwordController.text,
            _oldPasswordController.text
        );

        // Call the API to update the profile
        ProfileDTO newProfileInfoResult = await ApiService().updateProfile(profileData,_newProfileImage, context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(),
          ),
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).profileUpdated)),
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).profileUpdatedError)),
        );
      }
    }
  }

  // Pick Image Function
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newProfileImage = File(pickedFile.path);
      });

     // await ApiService().uploadImage(_profileImage!, context);
    }
  }
}

