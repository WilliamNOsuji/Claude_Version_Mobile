import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/pages/suggestion_page.dart';
import 'package:mobilelapincouvert/services/auth_service.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_home_page.dart';
import 'package:mobilelapincouvert/widgets/loadingPages/loading_homepage.dart';
import 'package:mobilelapincouvert/widgets/navbarWidgets/navBarNotDelivery.dart';
import '../dto/product.dart';
import '../generated/l10n.dart';
import '../web_interface/pages/web_home_page.dart';
import '../widgets/custom_app_bar.dart';
import '../services/api_service.dart';
import '../widgets/navbarWidgets/navBarDelivery.dart';
import 'ProductDetailPage.dart';
import '../models/colors.dart'; // Import your ApiService

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<IconData> navIcons = [Icons.home, Icons.shopping_cart, Icons.receipt, Icons.person];

List<String> navTile =["Home", "Panier", "Commande", "Profil"];

int selectedIndex = 0;

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();

  String? token; // will hold the token from login
  List<Product> products = []; // List to store products
  List<Product> AllProducts = [];
  bool isLoading = true; // Loading state
  String? selectedCategory;
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    var token = AuthService.getToken();
    fetchProducts(token);
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

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? WebHomePage() : Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: S.of(context).labelHome,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body:  RefreshIndicator(
        onRefresh: ()async {
          await fetchProducts(token);
          },
        color: AppColors().green(),
        child: isLoading ? shimmerHomePage()  : buidBody(),
      ),
    );
  }

  Widget buidBody() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              // Gradient Banner Section
              // Gradient Banner Section with Enhanced Design
              Container(
                width: double.infinity,
                height: 240,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Stack(
                    children: [
                      // Background Image
                      Image.asset(
                        "assets/images/snacks_image.jpg",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),

                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),

                      // Text Overlay
                      Positioned(
                        left: 20,
                        bottom: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              S.of(context).votezPourDesProduits,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                            // Subtitle
                            Text(
                              S.of(context).partagezVotreAvisSurNosProchainsProduits,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
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
              Container(
                height: 50, // Adjust height as needed
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      child: Row(
                        children: [
                          _buildCategoryButton(categories[index]),
                          SizedBox(width: 4)
                        ],
                      ),
                      onTap: (){
                        setState(() {
                          if(selectedCategory != categories[index]){
                            selectedCategory = categories[index];
                            products = AllProducts.where((p) => p.category.name == categories[index]).toList();
                          }else{
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = AllProducts[index];
                  return _buildProductCard(product);
                },
              )


            ],
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: !ApiService.isDelivery ?
            navBarFloatingNoDelivery(context, 0, setState) :
            navBarFloatingYesDelivery(context, 0, setState))

      ],
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
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
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
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
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
                          onPressed: () {
                            addCartProduct(product);
                          },
                          child: Text('Ajouter'),
                        ),
                      if (product.quantity <= 0)
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            width: 100,
                            padding: EdgeInsets.symmetric(vertical: 8.0,),
                            decoration: BoxDecoration(
                                color: AppColors().red().withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8.0)
                            ),
                            child: Text(S.of(context).noStockWidget, textAlign: TextAlign.center, style: TextStyle(color: AppColors().red(), fontWeight: FontWeight.bold),),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addCartProduct(Product product)async{

    String response = 'Erreur serveur';
    try {
      response = await ApiService().addCartProducts(
          context, product.id, ApiService.clientId, setState);
    }finally{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response))
      );

      fetchProducts(token);

    }
  }


}