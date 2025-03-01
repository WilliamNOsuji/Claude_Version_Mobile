import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/dto/auth.dart';
import 'package:mobilelapincouvert/pages/clientProfilePages/profile_edit_Page.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/navbarWidgets/navBarDelivery.dart';
import '../../widgets/navbarWidgets/navBarNotDelivery.dart';
import '../authenticationPages/loginPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

ProfileDTO? profile;
class _ProfilePageState extends State<ProfilePage> {
  String _selectedStatus = 'Inactif';

 void getProfileInfo() async {

   //setState(() { profile = null;});

   profile = await ApiService().getProfileInfo();

    if(profile == null){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }else{
      ApiService.isDelivery = profile!.isActiveAsDeliveryMan;
      profile!.isActiveAsDeliveryMan ? _selectedStatus = 'Actif' : _selectedStatus = 'Inactif';
      setState(() {});
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    getProfileInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profil',
        centerTitle: false,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: buildBody(),
      //bottomNavigationBar: ApiService.isDelivery? navBarWithDelivery(context, 4, setState) : navBarNoDelivery(context, 3, setState),
    );
  }


  Widget buildBody() {
    return Stack(
      children: [SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40,),
              // Profile Picture and Details
              Container(
                margin: const EdgeInsets.only(top: 24, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundColor: AppColors().green(),
                      child: CircleAvatar(
                        radius: 97,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: profile != null ? NetworkImage(profile!.imgUrl) : null,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      profile != null ? profile!.userName : 'chargement...',
                      style: TextStyle(
                        color: AppColors().black(),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      profile != null ? '${profile!.firstName} ${profile!.lastName}' : 'chargement...',
                      style: TextStyle(
                        color: AppColors().black(),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Status Dropdown Button
                    profile != null ? profile!.isDeliveryMan ?
                    PopupMenuButton<String>(
                      onSelected: (String newValue) async {
                          var response = await ApiService().becomeDeliveryMan();
                          if(response == 'State changed'){
                            getProfileInfo();
                          }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'Inactif',
                          child: Text('Inactif'),
                        ),
                        PopupMenuItem<String>(
                          value: 'Actif',
                          child: Text('Actif'),
                        ),

                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFECECEC), width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 11,
                              height: 11,
                              decoration: ShapeDecoration(
                                color: _selectedStatus == 'Actif' ? Color(0xFF5FAD41) : Colors.grey,
                                shape: OvalBorder(),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              _selectedStatus,
                              style: TextStyle(
                                color: Color(0xFF738290),
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: Color(0xFF738290)),
                          ],
                        ),
                      ),
                    ) : SizedBox() : SizedBox(),
                  ],
                ),
              ),
              // Delivery Mode Section
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'En mode livreur',
                      style: TextStyle(
                        color: Color(0xFF6A6A6A),
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0x30EA05FF),
                        child: Icon(Icons.delivery_dining, color: Colors.blue),
                      ),
                      title: profile == null ? Row(
                        children: [
                          SizedBox(height:20,width: 20, child: CircularProgressIndicator(color: AppColors().black())),
                          Expanded(child: SizedBox())
                        ],
                      ) :
                      Text(
                        !profile!.isDeliveryMan
                            ? 'Devenir livreur'
                            : 'Démissionner',
                        style: TextStyle(
                          color: Color(0xFF040926),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: (){
                        if(profile != null){
                          if(profile!.isDeliveryMan){
                            _showDialogResignDeliverMan();
                          }else{
                            _showDialogBecomeDeliverMan();
                          }
                        }
                      }
                    ),
                  ],
                ),
              ),
              // Edit Profile Section
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paramètres',
                      style: TextStyle(
                        color: Color(0xFF787878),
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xFF738290),
                        child: Icon(Icons.settings, color: Colors.white),
                      ),
                      title: Text(
                        'Modifier mon profil',
                        style: TextStyle(
                          color: Color(0xFF040926),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileEditPage(profile: profile!,),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Notifications Section
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0x3015B8FF),
                    child: Icon(Icons.notifications, color: Colors.blue),
                  ),
                  title: Text(
                    'Notifications',
                    style: TextStyle(
                      color: Color(0xFF040926),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              // About Section
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFF738290),
                    child: Icon(Icons.info, color: Colors.white),
                  ),
                  title: Text(
                    'À propos',
                    style: TextStyle(
                      color: Color(0xFF040926),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              // Logout Section
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFFD4911).withOpacity(0.2),
                    child: Icon(Icons.logout, color: Color(0xFFFD4911)),
                  ),
                  title: Text(
                    'Déconnexion',
                    style: TextStyle(
                      color: Color(0xFFFD4911),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: (){
                    AuthService.clearToken();
                    ApiService.clientId = null;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 125,)
            ],
          ),
        ),
      ),
        Align(
            alignment: Alignment.bottomCenter,
            child: !ApiService.isDelivery ?
            navBarFloatingNoDelivery(context, 3, setState) :
            navBarFloatingYesDelivery(context, 4, setState))
      ],

    );
  }

  void _showDialogBecomeDeliverMan() async{
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Devenir Livreur'),
            content: const Text(
                'Vous allez être actif en tant que livreur et vous pourrez livrer des commandes aux clients.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
                child: const Text(
                  'Annuler', style: TextStyle(color: Colors.blue),),
              ),
              TextButton(
                onPressed: () async {
                  await ApiService().becomeDeliveryMan();
                  getProfileInfo();
                  Navigator.pop(context); // Close dialog
                },
                child: const Text(
                  'Commencer', style: TextStyle(color: Colors.blue),),
              ),
            ],
          );
        },
      );
  }

  void _showDialogResignDeliverMan() async{
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Devenir Livreur'),
            content: const Text(
                'Vous n\'allez plus pouvoir être actif en tant que livreur et vous ne pourrez plus livrer des commandes aux clients.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
                child: const Text(
                  'Annuler', style: TextStyle(color: Colors.blue),),
              ),
              TextButton(
                onPressed: () async {
                  await ApiService().resign();
                  getProfileInfo();
                  Navigator.pop(context); // Close dialog
                },
                child: const Text(
                  'Demmissioner', style: TextStyle(color: Colors.red),),
              ),
            ],
          );
        },
      );
    }

}
