import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';

import '../../pages/suggestion_page.dart';

class WebFooter extends StatelessWidget {



  const WebFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen width to handle responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    Widget _buildWideHeroContent() {
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lapin Couvert',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors().white(),
                      fontSize: isSmallScreen ? 24 : 30,
                      fontFamily: GoogleFonts.satisfy().fontFamily,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Lapin Couvert est une entreprise de livraison innovante, spécialisée dans le transport rapide et sécurisé de colis pour particuliers et professionnels. Grâce à un réseau efficace et des solutions logistiques optimisées, nous garantissons des livraisons ponctuelles, quel que soit le volume ou la destination.Choisissez Lapin Couvert pour un service qui allie efficacité et confiance ! 🚀📦',
                          style: TextStyle(
                            color: AppColors().white(),
                            fontSize: 15,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                          ),
                        ),
                      ),
                      Expanded(child: Container())
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Liste des ?
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Entreprise',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 18 : 24,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 20),

                            Text(
                              'À propos',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              'Blogue',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              'Nos offres',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              'Nos offres',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              'Carrières',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),





                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Resources',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 18 : 24,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 20),

                            Text(
                              'Articles',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              'Centre d\'aide',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              'Investisseurs',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              'Investisseurs',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              'Communité',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Produits',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 18 : 24,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 20),

                            Text(
                              'Livreurs',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              'Courses',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              'Cartes Cadeaux',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              'Proposition',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Livraisons',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Parcours',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 18 : 24,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 20),

                            Text(
                              'Ivan',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              'Jin',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              'Jean-Pierre',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              'William',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              'Grégory',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors().white(),
                                fontSize: isSmallScreen ? 12 : 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),



                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,40,180,0),
                    child: Row(
                      children: [
                        Text("© 2025 Lapin Couvert Technologies Inc.",style: TextStyle(color: Colors.white),),



                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,20,0,0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Confidentialité",style: TextStyle(color: Colors.white),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Accessibilité",style: TextStyle(color: Colors.white),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Conditions",style: TextStyle(color: Colors.white),),
                        ),

                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),

        ],
      );
    }

    Widget _buildNarrowHeroContent() {
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lapin Couvert',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors().white(),
                      fontSize: isSmallScreen ? 24 : 30,
                      fontFamily: GoogleFonts.satisfy().fontFamily,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Text(
                            'Lapin Couvert est une entreprise de livraison innovante, spécialisée dans le transport rapide et sécurisé de colis pour particuliers et professionnels. Grâce à un réseau efficace et des solutions logistiques optimisées, nous garantissons des livraisons ponctuelles, quel que soit le volume ou la destination.Choisissez Lapin Couvert pour un service qui allie efficacité et confiance ! 🚀📦',
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: 15,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Liste des ?
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Entreprise',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 18 : 24,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 20),

                          Text(
                            'À propos',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            'Blogue',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            'Nos offres',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            'Nos offres',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Carrières',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),





                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Resources',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 18 : 24,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 20),

                          Text(
                            'Articles',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            'Centre d\'aide',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            'Investisseurs',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            'Investisseurs',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            'Communité',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Produits',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 18 : 24,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 20),

                          Text(
                            'Livreurs',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            'Courses',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            'Cartes Cadeaux',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            'Proposition',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Livraisons',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Parcours',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 18 : 24,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 20),

                          Text(
                            'Ivan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            'Jin',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            'Jean-Pierre',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            'William',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            'Grégory',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors().white(),
                              fontSize: isSmallScreen ? 12 : 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),



                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,40,180,0),
                    child: Row(
                      children: [
                        Text("© 2025 Lapin Couvert Technologies Inc.",style: TextStyle(color: Colors.white),),



                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,10,0,0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Confidentialité",style: TextStyle(color: Colors.white),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Accessibilité",style: TextStyle(color: Colors.white),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Conditions",style: TextStyle(color: Colors.white),),
                        ),

                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),

        ],
      );
    }
    double _getResponsiveHeight() {
      double screenWidth = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;
      if (screenWidth > 1400) {
        return height * 0.7;
      } else if (screenWidth > 1000) {
        return height * 0.75;
      } else if (screenWidth > 600) {
        return height * 0.8;
      } else {
        return height * 1.7; // Use more width on very small devices
      }
    }
    return Container(
      width: double.infinity,
      height: _getResponsiveHeight(),
      decoration: BoxDecoration(
        color: AppColors().green(),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout based on container width
          bool isWideScreen = constraints.maxWidth > 600;
          return isWideScreen
              ? _buildWideHeroContent()
              : _buildNarrowHeroContent();
        },
      ),

    );


  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
