// Custom Drawer implementation
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/models/profile_model.dart';
import 'package:mobilelapincouvert/pages/clientProfilePages/profilePage.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_profile_page.dart';
import 'package:mobilelapincouvert/pages/suggestion_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_home_page.dart';

import '../../dto/auth.dart';
import '../../models/colors.dart';
import '../../pages/authenticationPages/loginPage.dart';
import '../../pages/clientOrderPages/orderHistoryPage.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';

class WebMenuDrawer extends StatefulWidget {
  final ProfileDTO profileDTO;
  const WebMenuDrawer({
    super.key, required this.profileDTO});

  @override
  State<WebMenuDrawer> createState() => _WebMenuDrawerState();
}

class _WebMenuDrawerState extends State<WebMenuDrawer> with SingleTickerProviderStateMixin {
  // Track the currently hovered item
  String? hoveredItem;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return Drawer(
      elevation: 8.0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colors.white(),
              colors.white().withOpacity(0.95),
            ],
          ),
        ),
        child: Column(
          children: [
            // Drawer header with user info
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.green(),
                    colors.green().withOpacity(0.8),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.black().withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                accountName: Text(
                  '${widget.profileDTO.firstName} ${widget.profileDTO.lastName}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                accountEmail: null,
                currentAccountPicture: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.white(),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.black().withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: colors.white(),
                    backgroundImage: widget.profileDTO.imgUrl != ''
                        ? NetworkImage(widget.profileDTO.imgUrl)
                        : null,
                    child: widget.profileDTO.imgUrl == ''
                        ? Icon(
                      Icons.person,
                      color: colors.green(),
                      size: 40,
                    )
                        : null,
                  ),
                ),
                otherAccountsPictures: [
                  _buildStatusIndicator(colors),
                ],
                margin: EdgeInsets.zero,
              ),
            ),

            const SizedBox(height: 16),

            // Drawer items
            _buildDrawerItem(
              context,
              icon: Icons.home,
              title: 'Accueil',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebHomePage(),
                  ),
                );
              },
              colors: colors,
              itemName: 'home',
            ),

            _buildDrawerItem(
              context,
              icon: Icons.person,
              title: 'Profil',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebProfilePage(profileDTO: widget.profileDTO),
                  ),
                );
              },
              colors: colors,
              itemName: 'profile',
            ),

            _buildDrawerItem(
              context,
              icon: Icons.local_offer,
              title: 'Produits suggérés',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SuggestionPage(),
                  ),
                );
              },
              colors: colors,
              itemName: 'products',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.list_alt,
              title: 'Mes commandes',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderHistoryPage(),
                  ),
                );
              },
              colors: colors,
              itemName: 'commands',
            ),

            _buildDrawerItem(
              context,
              icon: Icons.info,
              title: 'À propos',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              },
              colors: colors,
              itemName: 'about',
            ),

            Divider(
              thickness: 1,
              color: colors.gray().withOpacity(0.3),
              indent: 16,
              endIndent: 16,
            ),

            _buildDrawerItem(
              context,
              icon: Icons.logout,
              title: 'Déconnexion',
              onTap: () {
                _showLogoutConfirmationDialog(context, colors);
              },
              colors: colors,
              isLogout: true,
              itemName: 'logout',
            ),

            const Spacer(),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colors.green().withOpacity(0.05),
                    colors.green().withOpacity(0.15),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pets,
                        color: colors.green(),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Lapin Couvert',
                        style: TextStyle(
                          color: colors.green(),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.pets,
                        color: colors.green(),
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '© 2025 Tous droits réservés',
                    style: TextStyle(
                      color: colors.gray(),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(AppColors colors) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.white(),
        border: Border.all(color: colors.white(), width: 2),
      ),
      child: Center(
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.green(),
            boxShadow: [
              BoxShadow(
                color: colors.green().withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        required AppColors colors,
        bool isLogout = false,
        required String itemName,
      }) {
    final isHovered = hoveredItem == itemName;

    return MouseRegion(
      onEnter: (_) => setState(() {
        hoveredItem = itemName;
        _animationController.forward();
      }),
      onExit: (_) => setState(() {
        hoveredItem = null;
        _animationController.reverse();
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isHovered
              ? (isLogout ? colors.red().withOpacity(0.1) :
          itemName == 'profile' ? AppColors().teal().withOpacity(0.1) :
          itemName == 'products' ? AppColors().orange().withOpacity(0.1) :
          itemName == 'about' ? colors.gray().withOpacity(0.1) :
          colors.green().withOpacity(0.1))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isHovered
              ? [
            BoxShadow(
              color: (isLogout ? colors.red() : colors.green()).withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: ScaleTransition(
          scale: isHovered ? _scaleAnimation : const AlwaysStoppedAnimation(1.0),
          child: ListTile(
            leading: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isHovered
                    ? (isLogout ? colors.red().withOpacity(0.2):
                itemName == 'profile' ? AppColors().teal().withOpacity(0.2) :
                itemName == 'products' ? AppColors().orange().withOpacity(0.2) :
                itemName == 'about' ? colors.gray().withOpacity(0.2) :
                colors.green().withOpacity(0.2))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isLogout
                    ? (isHovered ? colors.red() : colors.red().withOpacity(0.8))
                    :
                itemName == 'profile' ? AppColors().teal().withOpacity(0.8) :
                itemName == 'products' ? AppColors().orange().withOpacity(0.8) :
                itemName == 'about' ? colors.gray().withOpacity(0.8) :
                (isHovered ? colors.green() : colors.green().withOpacity(0.8)),
                size: 24,
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                color: isLogout
                    ? (isHovered ? colors.red() :
                itemName == 'profile' ? AppColors().teal().withOpacity(0.9) :
                itemName == 'products' ? AppColors().orange().withOpacity(0.9) :
                itemName == 'about' ? colors.gray().withOpacity(0.9) :
                colors.red().withOpacity(0.9)) :
                (isHovered ? colors.black() : colors.black().withOpacity(0.8)),
                fontSize: 16,
                fontWeight: isHovered ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            onTap: onTap,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context, AppColors colors) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Déconnexion',
          style: TextStyle(
            color: colors.black(),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir vous déconnecter?',
          style: TextStyle(
            color: colors.black().withOpacity(0.8),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: colors.white(),
        elevation: 8,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: TextStyle(
                color: colors.gray(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              AuthService.clearToken();
              ApiService.clientId = null;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.red(),
              foregroundColor: colors.white(),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Déconnecter'),
          ),
        ],
      ),
    );
  }
}