import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/widgets/bottom_nav.dart';
import 'package:mobilelapincouvert/widgets/drawer.dart';

import '../libhttp.dart';
import '../widgets/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  final _searchController = SearchController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: SideMenu(username: 'username'),
      appBar: CustomAppBar(title: 'Accueil', centerTitle: true),
      body: buidBody(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.lightbulb),
          onPressed: (){
            _sendNameToApiDiaog(context);
          }
      ),
      bottomNavigationBar: navigationBar(context, 0, setState),

    );
  }

  Widget buidBody(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SearchAnchor.bar(
                searchController: _searchController,
                barElevation: WidgetStatePropertyAll(4.0),
                barHintText: "Rechercher",
                /*builder: (BuildContext context, SearchController controller){
                    return SearchBar(
                      controller: searchController,
                      padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16.0)),
                      onTap: (){
                        controller.openView();
                      },
                      onChanged:(_){
                        controller.openView();
                      },
                      leading: const Icon(Icons.search),
                    );
                  },

                   */
                suggestionsBuilder:  (BuildContext context, SearchController controller){
                  return List<ListTile>.generate(5,(int index){
                    final String item = 'item $index';
                    return ListTile(
                      title: Text(item),
                      onTap: (){
                        setState(() {
                          controller.closeView(item);
                        });
                      },
                    );
                  });

                }
            ),
          ),

          Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Nombre de colonne  dans la grille
                      crossAxisSpacing: 16, // Defini l'espace entre les colonnes
                      mainAxisSpacing: 16 // Defini l'espace entre les Rows
                      //mainAxisExtent: 64, // (Optionnel) Spécifie la hauteur fixe en px de chaque élement dans la grille
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index){
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade100,
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(1, 1), // Décalage horizontal et vertical de l'ombre
                            ),
                          ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              height: 100,
                              width: 120,
                              child: Image.asset('assets/images/placeholder_image.webp', fit: BoxFit.cover,)),
                            Container(
                              margin: const EdgeInsets.only(top: 4.0),
                              child: Text('Produit $index',style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0, right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text( index == 3 ?'${index -1}.99 \$' :'$index.99 \$', style: TextStyle(fontWeight: FontWeight.bold, color:  index == 3 ? Colors.red : null ),),
                                      SizedBox(width: 8),
                                      index == 3 ? Text('$index.99',
                                        style: TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          color: Colors.black45
                                        )
                                      ) : SizedBox()
                                    ],
                                  ),
                                  IconButton(
                                      color: Color(0xFF2AB24A),
                                      onPressed: (){},
                                      icon: Icon(Icons.add_shopping_cart_outlined, size: 20))
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                ),
              )
          )

        ],
      ),
    );
  }


  void _sendNameToApiDiaog(BuildContext context) {

    TextEditingController _apitestController = TextEditingController();
    _apitestController.text = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Test API'),
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                const Text('Inscrivez votre Nom'),
                TextField(
                  controller: _apitestController,
                  keyboardType: TextInputType.name,
                  maxLength: 16,
                  decoration:  InputDecoration(
                      hintText:'Votre nom',
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {

                if(_apitestController.text.trim() != ''){
                  var response = await  testApi(context,_apitestController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response.toString())));
                  Navigator.pop(context);
                }
              },
              child: const Text('Envoyer'),
            ),
          ],
        );
      },
    );
  }
}
