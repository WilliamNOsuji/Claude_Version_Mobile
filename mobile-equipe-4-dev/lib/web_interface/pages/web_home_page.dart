import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/pages/ProductDetailPage.dart';
import 'package:mobilelapincouvert/pages/suggestion_page.dart';
import 'package:mobilelapincouvert/services/auth_service.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_product_detail_page.dart';
import 'package:mobilelapincouvert/web_interface/widgets/custom_app_bar.dart';
import 'package:mobilelapincouvert/web_interface/widgets/drawerCart.dart';
import 'package:mobilelapincouvert/widgets/loadingPages/loading_homepage.dart';
import '../../dto/auth.dart';
import '../../generated/l10n.dart';
import '../../models/product_model.dart';
import '../../models/colors.dart';
import '../../services/api_service.dart';

class WebHomePage extends StatefulWidget {
  const WebHomePage({super.key});

  @override
  State<WebHomePage> createState() => _WebHomePageState();
}

List<IconData> navIcons = [Icons.home, Icons.shopping_cart, Icons.receipt, Icons.person];

List<String> navTile =["Home", "Panier", "Commande", "Profil"];

int selectedIndex = 0;

class _WebHomePageState extends State<WebHomePage> {
  final searchController = TextEditingController();

  String? token; // will hold the token from login
  List<Product> products = []; // List to store products
  List<Product> AllProducts = [];
  bool isLoading = true; // Loading state
  String? selectedCategory;
  List<String> categories = [];
  List<CartProductDTO> listeCartProducts = [];
  @override
  void initState() {
    super.initState();
    var token = AuthService.getToken();
    fetchProducts(token);
    fetchCartProducts();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: LeTiroir(),
      appBar: WebCustomAppBar(),
      extendBodyBehindAppBar: true,
      body: isLoading ? shimmerHomePage(context, setState) : buidBody(),
    );
  }

  Widget buidBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 350,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border(),
          
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(80.0,80,0,0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Votez pour vos collations favoris!',
                                  style: TextStyle(
                                    color: AppColors().green(),
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                SizedBox(height: 20,),
                                // Subtitle
                                Text(
                                  'Parmi les sélections de collations dispoibles, votez pour la collation \nque vous voulez ajouter dans la liste des produits!',
                                  style: TextStyle(
                                    color: AppColors().green(),
                                    fontSize: 25,
                                    fontFamily: 'Inter',
                                  ),
                                ),
          
                                SizedBox(height: 20,),
          
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors().green(),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 110, vertical: 9),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child:  Text(
                                    'En savoir plus',
                                    textAlign: TextAlign.center,
          
                                  ),
                                )
                              ],
                            ),
                          ),
                          Spacer(),
                          Lottie.asset(
                            'assets/animations/webAccueilAnimation.json', // Path to your Lottie JSON file
                            height: 350,
                            fit: BoxFit.cover,
                          ),
                          Spacer(),
          
          
          
                        ],
          
                      ),
          
                      // Decorative Icon
                      Positioned(
                        right: 20,
                        bottom: 20,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.arrow_forward,color: Colors.white,size: 24,),
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SuggestionPage(),
                                ),
                              );
          
                            },
          
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          
              // Categories Section (Horizontal Scroll)
              SizedBox(
                height: 50, // Adjust height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  physics: AlwaysScrollableScrollPhysics(), // Ensures scrolling works
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: Row(
                        children: [
                          _buildCategoryButton(categories[index]),
                          SizedBox(width: 4),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          if (selectedCategory != categories[index]) {
                            selectedCategory = categories[index];
                            products = AllProducts.where((p) => p.category.name == categories[index]).toList();
                          } else {
                            selectedCategory = null;
                            products = AllProducts;
                          }
                        });
                      },
                    );
                  },
                ),
              ),


              // Product Grid Section
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20,20,20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductCard(product);
                },
              )
          
          
            ],
          ),
        ),
      ),
    );
  }

  Widget _navBar(){
    return Container(
      height: 65,
      margin: const EdgeInsets.only(right: 24,left: 24,bottom: 24),
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
        children: navIcons.map((icon){
          int index = navIcons.indexOf(icon);
          bool isSelected = selectedIndex == index;
          return Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if(selectedIndex == 1){

                  }
                  else if(selectedIndex ==2){

                  }
                  else if(selectedIndex ==3){

                  }
                  selectedIndex = index;
                });
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: 10,
                          bottom: 0,
                          left: 35,
                          right: 35
                      ),
                      child: Icon(
                        icon,
                        color: isSelected ? Colors.blue : Colors.grey,
                      ),
                    ),
                    Text(navTile[index], style: TextStyle(
                        color :isSelected ? Colors.blue : Colors.grey,
                        fontSize: 12),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
          );}).toList(),
      ),
    );
  }

// Helper method to build category buttons
  Widget _buildCategoryButton(String categoryName) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: (selectedCategory != null && selectedCategory == categoryName) ? AppColors().green() : AppColors().gray(),
        borderRadius: BorderRadius.circular(13),
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
    );
  }

// Helper method to build product cards
  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product, ),
          ),
        );
      },
      child: Hero(
        tag: product.photo!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.network(
                  product.photo ?? 'https://placehold.co/180x180',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),

              // Product Details
              Padding(
                padding: const EdgeInsets.fromLTRB(12,12,12,0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF040926),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.brand!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF738290),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            textAlign: TextAlign.right,
                            '(${product.category.name})',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors().gray(),
                              fontStyle: FontStyle.italic,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '\$${product.sellingPrice.toStringAsFixed(2)}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF5FAD41),
                          ),
                        ),
                        SizedBox(height: 5,),
                        if (product.quantity > 0)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors().black(),
                                foregroundColor: AppColors().white(),
                                minimumSize: Size(112, 36)
                            ),
                            onPressed: () async {
                              var response = await ApiService().addCartProducts(context,product.id,ApiService.clientId,setState,);
                              if (response == "Ce produit n'existe plus" || response == "Ce produit est épuisé") {
                                initState();
                              }
                            },
                            child: Text('Ajouter'),
                          ),
                        if (product.quantity <= 0)
                          Text(
                            S.of(context).noStockWidget,
                            style: TextStyle(
                              color: Color(0xFFC80000),
                              fontSize: 16,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}