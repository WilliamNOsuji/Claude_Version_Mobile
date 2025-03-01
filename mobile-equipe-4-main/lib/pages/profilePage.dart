import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/widgets/bottom_nav.dart';
import '../generated/l10n.dart';
import '../widgets/custom_app_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Profil', centerTitle: true),
      body: buildBody(),
      bottomNavigationBar: navigationBar(context, 2, setState),
    );
  }


  Widget buildBody(){
    return SingleChildScrollView(

      child: Column(
        children: [
          Divider(
            color: Color(0xFFCFCFCF),
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            width: 220,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: AssetImage('assets/images/profile_picture.webp'),
            ),
          ),
          Text('Jean Pierre', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          Text('1783527', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.green.shade900
            ),
            onPressed: (){
             Navigator.pushNamed(context, '/profileEditPage');
            },
              child: Text('Modifier mon profil')),
          Divider(
            color: Color(0xFFCFCFCF),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: [
                _infoCard('Email', '1783527@cegepmontpetit.ca', 6),

                _infoCard('Email', '1783527@cegepmontpetit.ca', 6),

                _infoCard('Email', '1783527@cegepmontpetit.ca', 6),

                _infoCard('Email', '1783527@cegepmontpetit.ca', 6),
              ],
            ),
          ),



          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Powered by ',
                    style:
                    TextStyle(fontSize: 10)
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

  Widget _infoCard(String title, String info, double espacement){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: espacement),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
        SizedBox(height: espacement),
        Text(info, style: TextStyle(fontSize: 16)),
        SizedBox(height: espacement),
        Divider(
          color: Color(0xFFCFCFCF),
        ),
      ],
    );
  }
}
