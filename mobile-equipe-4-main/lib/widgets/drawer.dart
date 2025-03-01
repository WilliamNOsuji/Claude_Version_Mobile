import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mobilelapincouvert/pages/HomePage.dart';
import 'package:mobilelapincouvert/pages/cart_page.dart';
import 'package:mobilelapincouvert/pages/checkout_page.dart';
import 'package:mobilelapincouvert/pages/loginPage.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key, required this.username});

  final String username;

  @override
  State<SideMenu> createState() => SideMenuState();
}

class SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    var listView = ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20,10,0),
          child: const DrawerHeader(

            child: Text('', style: TextStyle(color: Colors.black),),
            decoration: BoxDecoration(
                color: Colors.white60,
                image: DecorationImage(
                    image: AssetImage('assets/images/Logo.png'), fit: BoxFit.cover)
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0,10,0),
          child: Text('Bonjour ' + widget.username + '!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        ),
        ListTile(
          dense: true,
          leading: const Icon(Icons.home_filled),
          title: const Text("Accueil"),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
        ),
        ListTile(
          dense: true,
          leading: const Icon(Icons.shopping_cart),
          title: const Text("Panier"),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(),
              ),
            );
          },
        ),
        ListTile(
          dense: true,
          leading: const Icon(Icons.person),
          title: const Text("Profile"),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(), //ProfilePage
              ),
            );
          },
        ),

        ListTile(
          dense: true,
          leading: const Icon(Icons.logout),
          title: const Text("Déconnexion"),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
        ),
      ],
    );

    return Drawer(
      child: Container(
        color: const Color(0xFFFFFFFF),
        child: listView,
      ),
    );
  }
}