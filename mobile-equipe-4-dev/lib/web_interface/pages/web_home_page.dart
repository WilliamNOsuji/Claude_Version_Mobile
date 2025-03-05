import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/pages/ProductDetailPage.dart';
import 'package:mobilelapincouvert/pages/suggestion_page.dart';
import 'package:mobilelapincouvert/services/auth_service.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_product_detail_page.dart';
import 'package:mobilelapincouvert/web_interface/widgets/custom_app_bar.dart';
import 'package:mobilelapincouvert/web_interface/widgets/drawerCart.dart';
import 'package:mobilelapincouvert/web_interface/widgets/footer.dart';
import 'package:mobilelapincouvert/web_interface/widgets/web_menu_drawer.dart';
import 'package:mobilelapincouvert/widgets/loadingPages/loading_homepage.dart';
import 'package:mobilelapincouvert/widgets/loadingPages/loading_web_homepage.dart';
import '../../dto/auth.dart';
import '../../dto/product.dart';
import '../../generated/l10n.dart';
import '../../models/colors.dart';
import '../../services/api_service.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // Add this package

class WebHomePage extends StatefulWidget {
  const WebHomePage({super.key});

  @override
  State<WebHomePage> createState() => _WebHomePageState();
}

List<IconData> navIcons = [Icons.home, Icons.shopping_cart, Icons.receipt, Icons.person];
bool croissantClicked = false;
bool legumesfruitsClicked = false;
bool viandesClicked = false;
bool biscuitsClicked = false;
bool drinksClicked = false;
bool coldClicked = false;
bool smalGroceryClicked = false;
List<String> navTile =["Accueil", "Panier", "Commande", "Profil"];

int selectedIndex = 0;

class _WebHomePageState extends State<WebHomePage> with SingleTickerProviderStateMixin {
  final searchController = TextEditingController();
  final ScrollController _categoriesScrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String? token; // will hold the token from login
  List<Product> products = []; // List to store products
  List<Product> AllProducts = [];
  bool isLoading = true; // Loading state
  String? selectedCategory;
  List<String> categories = [];
  List<CartProductDTO> listeCartProducts = [];
  ProfileDTO? profileDTO;

  @override
  void initState() {
    super.initState();
    var token = AuthService.getToken();
    fetchProducts(token);
    fetchCartProducts();
    getProfile();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _categoriesScrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the token from the route arguments.
    if (token == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        token = args;
      }
    }
  }

  Future<void> fetchProducts(var token) async {
    try {
      setState(() => isLoading = true);
      if (token != null) {
        // Can put parameter token in getProducts
        final fetchedProducts = await ApiService().getProducts(token);

        setState(() {
          products = fetchedProducts;
          AllProducts = products;
          isLoading = false;
          fetchedProducts.forEach((p) {
            if(!categories.contains(p.category.name)){
              categories.add(p.category.name);
            };
          });
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchCartProducts() async {
    try{
      var token = AuthService.getToken();
      List<CartProductDTO> response = await ApiService().getCartProducts(token, ApiService.clientId);
      listeCartProducts = response;
    }catch (Exception){

    }
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
      drawer: profileDTO != null ? WebMenuDrawer(profileDTO: profileDTO!) : null,
      appBar: WebCustomAppBar(),
      //extendBodyBehindAppBar: true,
      body: isLoading ? shimmerWebHomePage(context) : buidBody(),
    );
  }

// Improve responsive width calculation for different screen sizes
  double _getResponsiveWidth() {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1400) {
      return screenWidth * 0.7;
    } else if (screenWidth > 1000) {
      return screenWidth * 0.8;
    } else if (screenWidth > 600) {
      return screenWidth * 0.9;
    } else {
      return screenWidth * 0.95; // Use more width on very small devices
    }
  }

// Improve product grid count calculation for better responsiveness
  int _getResponsiveGridCount() {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1600) {
      return 5;
    } else if (screenWidth > 1400) {
      return 4;
    } else if (screenWidth > 1000) {
      return 3;
    } else if (screenWidth > 600) {
      return 2;
    } else {
      return 1;
    }
  }

  Widget buidBody() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: _getResponsiveWidth(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeroSection(),
                    // Replace the Row of categories with a GridView
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Determine number of columns based on width
                            int crossAxisCount = _getResponsiveCategoryCount(constraints.maxWidth);
                            return GridView.count(
                              crossAxisCount: crossAxisCount,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1.0,
                              children: [
                                _buildCategoryItem(
                                    'Boulangerie',
                                    'assets/images/croissant_image.png',
                                    'assets/animations/croissant_animation.json',
                                    croissantClicked,
                                        () {
                                      if(croissantClicked){
                                        setState(() {
                                          croissantClicked = !croissantClicked;
                                          products = AllProducts;
                                        });
                                      }else{
                                        resetCategories();
                                        setState(() {
                                          croissantClicked = !croissantClicked;
                                          products = AllProducts.where((p) => p.category.name == 'Boulangerie').toList();
                                        });
                                      }
                                    }
                                ),
                                _buildCategoryItem(
                                    'Fruits & Legumes',
                                    'assets/images/fruits_legumes.png',
                                    'assets/animations/fruits_legumes.json',
                                    legumesfruitsClicked,
                                        () {
                                      if(legumesfruitsClicked){
                                        setState(() {
                                          legumesfruitsClicked = !legumesfruitsClicked;
                                          products = AllProducts;
                                        });
                                      }else{
                                        resetCategories();
                                        setState(() {
                                          legumesfruitsClicked = !legumesfruitsClicked;
                                          products = AllProducts.where((p) => p.category.name == 'Fruits').toList();
                                          products.addAll(AllProducts.where((p) => p.category.name == 'Légumes').toList());
                                          products.addAll(AllProducts.where((p) => p.category.name == 'Légumineuses').toList());
                                        });
                                      }
                                    }
                                ),
                                // Continue with other categories...
                                _buildCategoryItem(
                                    'Viandes & Fruits de mer',
                                    'assets/images/viandes.png',
                                    'assets/animations/viandes.json',
                                    viandesClicked,
                                        () {
                                      if(viandesClicked){
                                        setState(() {
                                          viandesClicked = !viandesClicked;
                                          products = AllProducts;
                                        });
                                      }else{
                                        resetCategories();
                                        setState(() {
                                          viandesClicked = !viandesClicked;
                                          products = AllProducts.where((p) => p.category.name == 'Viande').toList();
                                          products.addAll(AllProducts.where((p) => p.category.name == 'Fruits de Mer').toList());
                                        });
                                      }
                                    }
                                ),
                                _buildCategoryItem(
                                    'Biscuits & Croustilles',
                                    'assets/images/biscuits.png',
                                    'assets/animations/biscuits.json',
                                    biscuitsClicked,
                                        () {
                                      if(biscuitsClicked){
                                        setState(() {
                                          biscuitsClicked = !biscuitsClicked;
                                          products = AllProducts;
                                        });
                                      }else{
                                        resetCategories();
                                        setState(() {
                                          biscuitsClicked = !biscuitsClicked;
                                          products = AllProducts.where((p) => p.category.name == 'Biscuits').toList();
                                          products.addAll(AllProducts.where((p) => p.category.name == 'Biscuits Salés').toList());
                                          products.addAll(AllProducts.where((p) => p.category.name == 'En-cas').toList());
                                        });
                                      }
                                    }
                                ),
                                _buildCategoryItem(
                                    'Boissons et laitiers',
                                    'assets/images/bear_drinks.png',
                                    'assets/animations/bear_drinks_animation.json',
                                    drinksClicked,
                                        () {
                                      if(drinksClicked){
                                        setState(() {
                                          drinksClicked = !drinksClicked;
                                          products = AllProducts;
                                        });
                                      }else{
                                        resetCategories();
                                        setState(() {
                                          drinksClicked = !drinksClicked;
                                          products = AllProducts.where((p) => p.category.name == 'Boissons').toList();
                                          products.addAll(AllProducts.where((p) => p.category.name == 'Produits Laitiers').toList());
                                        });
                                      }
                                    }
                                ),
                                _buildCategoryItem(
                                    'Congelés',
                                    'assets/images/ice_cream.png',
                                    'assets/animations/ice_cream_animation.json',
                                    coldClicked,
                                        () {
                                      if(coldClicked){
                                        setState(() {
                                          coldClicked = !coldClicked;
                                          products = AllProducts;
                                        });
                                      }else{
                                        resetCategories();
                                        setState(() {
                                          coldClicked = !coldClicked;
                                          products = AllProducts.where((p) => p.category.name == 'Congelés').toList();
                                        });
                                      }
                                    }
                                ),
                                _buildCategoryItem(
                                    'Petite épicerie',
                                    'assets/images/grocery.png',
                                    'assets/animations/groceries_animation.json',
                                    smalGroceryClicked,
                                        () {
                                      if(smalGroceryClicked){
                                        setState(() {
                                          smalGroceryClicked = !smalGroceryClicked;
                                          products = AllProducts;
                                        });
                                      }else{
                                        resetCategories();
                                        setState(() {
                                          smalGroceryClicked = !smalGroceryClicked;
                                          products = AllProducts.where((p) => p.category.name == 'Produits en Conserve').toList();
                                          products.addAll(AllProducts.where((p) => p.category.name == 'Sauces').toList());
                                          products.addAll(AllProducts.where((p) => p.category.name == 'Pâtes').toList());
                                          products.addAll(AllProducts.where((p) => p.category.name == 'Céréales').toList());
                                        });
                                      }
                                    }
                                ),
                              ],
                            );
                          }
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Product Grid Section with animation
                    AnimationLimiter(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _getResponsiveGridCount(),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75, // Adjust for better fit
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            columnCount: _getResponsiveGridCount(),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: _buildProductCard(products[index]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              WebFooter()
            ],
          ),
        ),
      ),
    );
  }

  // Add this method to determine number of categories per row based on screen width
  int _getResponsiveCategoryCount(double width) {
    if (width > 1000) {
      return 7; // Show all categories in one row on large screens
    } else if (width > 600) {
      return 3; // 3 categories per row
    } else {
      return 2; // 2 categories per row for small devices
    }
  }

// Add this helper widget method for building category items
  Widget _buildCategoryItem(String title, String imagePath, String animationPath, bool isClicked, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              padding: isClicked ? EdgeInsets.all(4) : null,
              decoration: BoxDecoration(
                  color: isClicked ? AppColors().red() : null,
                  shape: isClicked ? BoxShape.circle : BoxShape.rectangle
              ),
              child: isClicked
                  ? Lottie.asset(
                animationPath,
                fit: BoxFit.contain,
              )
                  : Image.asset(imagePath),
            ),
            SizedBox(height: isClicked? 8 : 0),
            Text(
              title,
              style: TextStyle(
                  fontWeight: isClicked ? FontWeight.bold : FontWeight.normal,
                  color: AppColors().black(),
                  fontSize: isClicked ? 16 : null,
                  fontFamily: GoogleFonts.roboto().fontFamily
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout based on container width
          bool isWideScreen = constraints.maxWidth > 700;
          return isWideScreen
              ? _buildWideHeroContent()
              : _buildNarrowHeroContent();
        },
      ),
    );
  }

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
                  'Votez pour vos collations favoris!',
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: TextStyle(
                    color: AppColors().black(),
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Parmi les sélections de collations dispoibles, votez pour la collation que vous voulez ajouter dans la liste des produits!',
                  style: TextStyle(
                    color: AppColors().gray(),
                    fontSize: 18,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                  ),
                ),
                const SizedBox(height: 30),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const SuggestionPage(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;
                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(position: offsetAnimation, child: child);
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().red(),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'En savoir plus',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 18),
                          Icon(Icons.local_dining, size:18, color: Colors.white,)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Lottie.asset(
            'assets/animations/webAccueilAnimation.json',
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowHeroContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/animations/webAccueilAnimation.json',
          height: 150,
          fit: BoxFit.contain,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Votez pour vos collations favoris!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors().black(),
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Parmi les sélections de collations dispoibles, votez pour vos favoris!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors().gray(),
                fontSize: 14,
                fontFamily: GoogleFonts.roboto().fontFamily,
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const SuggestionPage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(position: offsetAnimation, child: child);
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors().red(),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'En savoir plus',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 18),
                  Icon(Icons.local_dining, size:18, color: Colors.white,)
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _navBar() {
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: navIcons.map((icon) {
          int index = navIcons.indexOf(icon);
          bool isSelected = selectedIndex == index;
          return Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedIndex == 1) {

                  }
                  else if (selectedIndex == 2) {

                  }
                  else if (selectedIndex == 3) {

                  }
                  selectedIndex = index;
                });
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(
                          top: 10,
                          bottom: 0,
                          left: 35,
                          right: 35
                      ),
                      child: Icon(
                        icon,
                        color: isSelected ? AppColors().green() : AppColors().gray(),
                      ),
                    ),
                    Text(
                      navTile[index],
                      style: TextStyle(
                          color: isSelected ? AppColors().green() : AppColors().gray(),
                          fontSize: 12
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Improved category button with hover effect
  Widget _buildCategoryButton(String categoryName) {
    bool isSelected = selectedCategory != null && selectedCategory == categoryName;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors().green() : AppColors().gray().withOpacity(0.8),
          borderRadius: BorderRadius.circular(13),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors().green().withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ] : null,
        ),
        child: Text(
          categoryName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // Improved product card with hover effect
  Widget _buildProductCard(Product product) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if(profileDTO!= null){
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => WebProductDetailPage(product: product, profileDTO: profileDTO!,),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          }
        },
        child: Hero(
          tag: product.photo!,
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image with hover zoom effect
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: MouseRegion(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                product.photo ?? 'https://placehold.co/180x180',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: product.quantity < 25 ?  Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColors().red(),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Row(
                                  children: [
                                    Text('Plus que ${product.quantity} restants!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                                    SizedBox(width: 6),
                                    Icon(
                                      Icons.bolt,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ) : SizedBox(),
                            ),
                            Positioned(
                              top: 12,
                              left: 0,
                              child: product.sellingPrice < 25 ?  Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColors().green(),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Row(
                                  children: [
                                    Text('Plus bas prix !', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                                    SizedBox(width: 6),
                                    Icon(
                                      Icons.trending_down,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ) : SizedBox(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Product Details
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors().black(),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                product.brand!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors().gray(),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '(${product.category.name})',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors().gray().withOpacity(0.7),
                                  fontStyle: FontStyle.italic,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${product.sellingPrice.toStringAsFixed(2)}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors().green(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (product.quantity > 0)
                          SizedBox(
                            width: double.infinity,
                            child: MouseRegion(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors().black(),
                                  foregroundColor: AppColors().white(),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  var response = await ApiService().addCartProducts(
                                    context,
                                    product.id,
                                    ApiService.clientId,
                                    setState,
                                  );
                                  if (response == "Ce produit n'existe plus" || response == "Ce produit est épuisé") {
                                    initState();
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.shopping_cart, size: 16, color: AppColors().white(),),
                                    const SizedBox(width: 18),
                                    const Text('Ajouter'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (product.quantity <= 0)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFFF8D7DA),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              S.of(context).noStockWidget,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFC80000),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void resetCategories(){
    setState(() {
      croissantClicked = false;
      legumesfruitsClicked = false;
      viandesClicked = false;
      biscuitsClicked = false;
      drinksClicked = false;
      coldClicked = false;
      smalGroceryClicked = false;
    });
  }
}