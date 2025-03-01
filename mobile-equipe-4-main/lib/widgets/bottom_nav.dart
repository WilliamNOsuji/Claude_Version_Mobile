
// Ce widget est utilisé pour la navigation en bas de l'écran
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

int currentPage = -1;

BottomNavigationBar navigationBar(BuildContext context, int _selectedIndex, StateSetter setState){
  currentPage = _selectedIndex;

  // Méthode qui vérifie si l'utilisateur se trouve à la meme page
  bool onTheSamePage(String pageName){
    // Obtenir le nom de la route actuelle
    final currentRoute = ModalRoute.of(context)?.settings.name;
    // Vérifier si vous êtes déjà sur la page '/acceuil'
    if (currentRoute != pageName) {
      return false; // on est pas sur la même page
    } else {
      return true; // on est sur la meme page
    }
  }

  // Retour du Widget
  return BottomNavigationBar(
    currentIndex: _selectedIndex, // Ajout pour suivre l'onglet actif
    onTap: (index) {
      setState(() {
        _selectedIndex = index; // Met à jour l'onglet actif
      });

      switch(index){
        case 0 :
        //Navigation vers Espace
          if(!onTheSamePage('/homePage')){
            Navigator.pushNamed(context, '/homePage');
          }
          break;
        case 1 :
        //Navigation vers le panier
          if(!onTheSamePage('/cartPage')){
            Navigator.pushNamed(context, '/cartPage');
          }
          break;
        case 2 :
        //Navigation vers Acceuil
          if(!onTheSamePage('/profilePage')){
            Navigator.pushNamed(context, '/profilePage');
          }
          break;
      }
    },
    items: [
      BottomNavigationBarItem(
        icon: const Icon(Icons.dashboard_outlined), // Icône représentative pour Accueil
        activeIcon: const Icon(Icons.dashboard,color:  Color(0xFF2AB24A)), // Icône pour l'état actif
        label: S.of(context).labelHome,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.shopping_cart_outlined), // Icône représentative pour Accueil
        activeIcon: const Icon(Icons.shopping_cart, color: Color(0xFF2AB24A)), // Icône pour l'état actif
        label: S.of(context).labelcart,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_outline), // Icône plus moderne pour un espace famille
        activeIcon: const Icon(Icons.person, color: Color(0xFF2AB24A)), // Icône pour l'état actif
        label: S.of(context).labelProfil,
      ),
    ],
    selectedItemColor: Color(0xFF2AB24A),

    // Couleur des icônes actives
    unselectedItemColor: Colors.grey, // Couleur des icônes inactives
    type: BottomNavigationBarType.fixed, // Assure un comportement stable
    elevation: 8, // Ajoute une ombre pour un meilleur visuel
  );
}