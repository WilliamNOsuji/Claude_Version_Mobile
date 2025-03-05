import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_edit_profile_page.dart';

import '../../dto/auth.dart';
import '../../services/api_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/drawerCart.dart';
import '../widgets/web_menu_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WebProfilePage extends StatefulWidget {
  final ProfileDTO profileDTO;
  const WebProfilePage({super.key, required this.profileDTO});

  @override
  _WebProfilePageState createState() => _WebProfilePageState();
}

class _WebProfilePageState extends State<WebProfilePage> {
  ProfileDTO? profileDTO;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }
  Future<void> getProfile() async {
    try{
      profileDTO = await ApiService().getProfileInfo();
    }catch (Exception){

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
            width: 741,
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 84),
                Container(
                  width: 240, // Diameter (radius * 2)
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 2), // Thin border
                  ),
                  child: CircleAvatar(
                    radius: 120,
                    backgroundImage: Image.network(widget.profileDTO.imgUrl).image,
                  ),
                ),
                SizedBox(height: 29),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset('assets/images/icon_profile_state.svg'),
                      SizedBox(width: 8),
                      Text(
                        'En ligne',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 84),
                ProfileField(label: 'Nom de famille', value: widget.profileDTO.lastName),
                SizedBox(height: 22),
                ProfileField(label: 'Prénom', value: widget.profileDTO.firstName),
                SizedBox(height: 84),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5FAD41),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebEditProfilePage(profileDTO:widget.profileDTO ),
                      ),
                    );
                  },
                  child: Text(
                    'Modifier',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Color(0xFF738290)),
        ),
        SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFEFEFEF), width: 1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: Color(0xFF738290)),
          ),
        ),
      ],
    );
  }
}
