import 'package:badges/badges.dart' as badges;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/pages/clientProfilePages/profilePage.dart';
import 'package:mobilelapincouvert/pages/clientOrderPages/orderHistoryPage.dart';

import '../../dto/auth.dart';
import '../../pages/HomePage.dart';
import '../../pages/paymentProcessPages/cart_page.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';

Widget navBarFloatingNoDelivery(BuildContext context, int _selectedIndex , StateSetter setState) {
  int currentPage = _selectedIndex;

  List<Widget> navIcons = [
    Icon(Icons.home),
    badges.Badge(
      badgeContent: Text(
          ApiService.CartItemCount.toString(), style: TextStyle(color: Colors.white)
      ),
      showBadge: ApiService.CartItemCount > 0,
      child: const Icon(Icons.shopping_cart_outlined
      ),
    ),
    Icon(Icons.receipt,
      ),
    Icon(Icons.person)
  ];

  List<String> navTile =["Home", "Panier", "Commande", "Profil"];


  // Method to check if the user is on the same page
  bool onTheSamePage(String pageName) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return currentRoute == pageName;
  }

 List<Widget> navIconsWidget(bool isSelected){
    return [
      Icon(Icons.home, color: isSelected ? Colors.blue : Colors.grey,),
      badges.Badge(
        badgeContent: Text(
            ApiService.CartItemCount.toString(), style: TextStyle(color: Colors.white)
        ),
        showBadge: ApiService.CartItemCount > 0,
        child: Icon(Icons.shopping_cart_outlined, color: isSelected ? Colors.blue : Colors.grey,
        ),
      ),
      Icon(Icons.receipt,
        color: isSelected ? Colors.blue : Colors.grey,),
      Icon(Icons.person,color: isSelected ? Colors.blue : Colors.grey,)
    ];
 }

  return Container(
    height: 65,
    margin: const EdgeInsets.only(right: 24, left: 24, bottom: 24),
    decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400]!,
            blurRadius: 5,
          )
        ]
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: navIcons.map((icon) {
        int index = navIcons.indexOf(icon);
        bool isSelected = _selectedIndex == index;
        return Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () async {
              setState(() {
                // Update selected index
                _selectedIndex = index;
              });

                // Navigate to appropriate page based on selection
                if (index == 0) {
                  if (!onTheSamePage('/homePage')) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  }
                } else if (index == 1) {
                  if (!onTheSamePage('/cartPage')) {
                    var token = AuthService.getToken();
                    try {
                      List<CartProductDTO> response =
                      await ApiService().getCartProducts(token, ApiService.clientId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartPage(CardProducts: response),
                        ),
                      );
                    } on DioException catch (e) {
                      // Handle error appropriately (e.g., show a snackbar or alert)
                    }
                  }
                } else if (index == 2) {
                  if (!onTheSamePage('/orderListPage')) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderHistoryPage(),
                      ),
                    );
                  }
                } else if (index == 3) {
                  if (!onTheSamePage('/profilePage')) {
                    ProfileDTO? profileInfo = await ApiService().getProfileInfo();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ),
                    );
                  }
                }
              ;
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  //margin: EdgeInsets.only(top: 10, bottom: 0, left: 35, right: 35),
                  child: navIconsWidget(isSelected)[index],
                ),
                Text(
                  navTile[index],
                  style: TextStyle(
                    color: isSelected ? Colors.blue : Colors.grey,
                    fontSize: 12,
                  ),
                ),
               /* SizedBox(
                  height: 10,
                ) */
              ],
            ),
          ),
        );
      }).toList(),
    ),
  );
}
