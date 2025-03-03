import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mobilelapincouvert/dto/vote.dart';

import '../dto/auth.dart';
import '../dto/payment.dart';
import '../gestion_erreurs.dart';
import '../models/product_model.dart';
import '../pages/clientOrderPages/orderHistoryPage.dart';
import '../pages/paymentProcessPages/order_success_page.dart';
import 'chat_service.dart';
import 'auth_service.dart';
import 'local_storage_stripe_service.dart';
import 'dart:html' as html;

//Web
const String BaseUrl = kIsWeb ? "http://127.0.0.1:5180" : "http://10.0.2.2:5180";

// Mobile
//const String BaseUrl= "http://10.0.2.2:5180";

// Deployed
//const String BaseUrl ="https://api-lapincouvert-hke0a0a6cjg5c3gh.canadacentral-01.azurewebsites.net";

class ApiService {
  static var clientId = null;
  static double subTotal = 0;
  static double finalAmount = 0;
  static String address = '';
  static String phoneNum = '';
  static String  currency = "cad";
  static int CartItemCount = 0;
  static bool isDelivery = false;
  static bool isActive = false;


  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: BaseUrl,
      //baseUrl: BaseUrlDeployed,
      //baseUrl: BaseUrlDeployed,
      connectTimeout: const Duration(seconds: 100),
      receiveTimeout: const Duration(seconds: 100),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // Add interceptors for logging or adding headers
  ApiService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await AuthService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          return handler.next(error);
        },
      ),
    );
  }



  Future<SigninSuccessDTO?> register(BuildContext context, RegisterDTO registerDTO) async {
    try{
      final response = await _dio.post('$BaseUrl/api/Account/Register', data: registerDTO.toJson());

      SigninSuccessDTO signinSuccessDTO = SigninSuccessDTO.fromJson(response.data);
      ApiService.clientId = signinSuccessDTO.clientId;
      ApiService.isDelivery = signinSuccessDTO.isDeliveryMan;
      ApiService.isActive = signinSuccessDTO.isActive;

      return signinSuccessDTO;
    } on DioException catch(e){
      print(e);
      if(e.response!.statusCode == 500){
        showErrorMessage(context,"Cette utilisateur existe déjà");
      }


      if(e.response!.statusCode == 400){
        showErrorMessage(context,"Mot de passe doit contenir, un chiffre, un majuscule et caractère speciale");
      }

      if(e.type == DioExceptionType.connectionError){
        showErrorMessage(context, "Il y a eu une erreur de connection");
      }
    }
    return null;
  }

  Future<SigninSuccessDTO?> login(BuildContext context, SigninDTO signinDTO) async {
    try {
      final response = await _dio.post(
        '/api/Account/Login',
        data: signinDTO.toJson(),
      );

      SigninSuccessDTO signinSuccessDTO = SigninSuccessDTO.fromJson(response.data);
      ApiService.clientId = signinSuccessDTO.clientId;
      ApiService.isDelivery = signinSuccessDTO.isDeliveryMan && signinSuccessDTO.isActive;
      ApiService.isActive = signinSuccessDTO.isActive;

      return signinSuccessDTO;
    } on DioException catch(e) {
      if(e.type == DioExceptionType.badResponse){
        showErrorMessage(context, 'Les identifiants sont invalides, veuillez vous inscrire');
      }
    }
    return null;
  }

  // Fetch all products
  Future<List<Product>> getProducts(var token) async {
    try {
      final response = await _dio.get('/api/Products/GetProducts');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    }
  }

  Future<List<CartProductDTO>> getCartProducts(var token, int clientId) async {
    try {
      final response = await _dio.get('/api/Cart/GetCartProducts/$clientId');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => CartProductDTO.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    }
  }

  Future<String> addCartProducts(BuildContext context,int productId, int clientId, StateSetter setState) async {
    
    try {
      var response = await _dio.post('/api/Cart/AddCartProduct/$productId/$clientId');
      if (response.statusCode == 200) {

        if(response.toString() != 'Produit existe déjà'){
          setState(() {
            ApiService.CartItemCount++;
          });
        }
      } else {
        throw Exception('Failed to load products');
      }
      return response.toString();
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    }
  }

  Future<void> addQuantityCartProducts(BuildContext context,int productId, int clientId) async {

    try {
      var response = await _dio.post('/api/Cart/AddQuantityCartProduct/$productId/$clientId');
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    }
  }

  Future<void> decreaseQuantityCartProducts(BuildContext context,int productId, int clientId) async {

    try {
      var response = await _dio.post('/api/Cart/DecreaseQuantityCartProduct/$productId/$clientId');
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    }


  }

  Future<void> deleteCartProducts(BuildContext context,int productId, int clientId) async {

    try {
      var response = await _dio.post('/api/Cart/DeleteCartProduct/$productId/$clientId');
      if (response.statusCode == 200) {

      } else {
        throw Exception('Failed to load products');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    }


  }

  Future<String> validateCartProducts(BuildContext context, List<CartProductDTO> cartProducts) async {

    try {
      List<Map<String, dynamic>> jsonList = cartProducts.map((product) => product.toJson()).toList();

      var response = await _dio.post('/api/Cart/ValidateCartProduct', data: jsonList);
      if (response.statusCode == 200) {
        return response.toString();
      } else {
        throw Exception('Failed to load products');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    }

  }

  Future<Command?> MakePayment(BuildContext context, CommandDTO commandDTO, List<CartProductDTO> cartProducts) async {
    try {
      // Step 1: Validate cart products
      var validationResponse = await ApiService().validateCartProducts(context, cartProducts);
      if (validationResponse.toString() == "Le panier est valide") {
        // Step 2: Get payment intent from Stripe
        var paymentIntentResponse = await ApiService().getPaymentIntent(ApiService.finalAmount, ApiService.currency);
        await ApiService().initPaymentSheet(paymentIntentResponse);

        // Step 3: Present the payment sheet
        await Stripe.instance.presentPaymentSheet();

        // Step 4: If payment is successful, create the command
        return await ApiService().CreateCommand(commandDTO);
      }
    } catch (e) {
      print("Payment error: $e");
    }
    return null; // Return null if payment fails
  }

  Future<Command> CreateCommand (CommandDTO commandDTO) async{
    try{
      var response = await _dio.post('/api/Commands/Create', data: commandDTO.toJson());
      Command commandSuccess = Command.fromJson(response.data);
      print(response.data);
      return commandSuccess;
    }on DioException catch(e){
      throw Exception();
    }
  }

  Future<String> becomeDeliveryMan () async{
    try{
      var deviceToken  = FirebaseMessaging.instance.getToken();
      var response = await _dio.get('/api/Delivery/BecomeDeliveryMan/${deviceToken}');
      print(response.data);
      return response.data.toString();
    }on DioException catch(e){
      throw Exception();
    }
  }

  Future<String> resign() async{
    try{
      final token = await AuthService.getToken();
      var response = await _dio.get('/api/Delivery/Resign',
        options: Options(
        headers: {
          'Authorization': 'Bearer $token', // Ajoute le token ici
        },
      ),);

      print(response.data);
      return response.data.toString();
    }on DioException catch(e){
      throw Exception();
    }
  }

  Future<void> checkToken() async {
    try {
      final token = await AuthService.getToken();
      var response = await _dio.get(
        '/api/Delivery/CheckToken',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('Token Claims: ${response.data}');
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode} - ${e.response?.data}');
    }
  }

  Future<List<Command>> getClientCommads() async {

    List<Command> listCommand = [];

    try{
      var response = await _dio.get('/api/Commands/GetClientCommands');
      if(response.statusCode == 200){
        List<dynamic> data = response.data;
        listCommand = data.map((json) => Command.fromJson(json)).toList();
        return listCommand;
      }

    }catch(e){
      throw Exception();
    }

    return listCommand;
  }

  Future<List<Command>> getAllAvailableCommands() async {

    List<Command> listCommand = [];

    try{
      var response = await _dio.get('/api/Commands/GetAllAvailableCommands');
      if(response.statusCode == 200){
        List<dynamic> data = response.data;
        listCommand = data.map((json) => Command.fromJson(json)).toList();
        return listCommand;
      }

    }catch(e){
      throw Exception();
    }

    return listCommand;
  }

  Future<void> PaiementRequest(BuildContext context, List<CartProductDTO> cartproducts) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      List<String> tokens = [];
      if (token != null) {
        tokens.add(token);
      }
      CommandDTO commandDTO = CommandDTO(
          address,
          currency,
          finalAmount,
          phoneNum,
          tokens);

      // Step 1: Validate cart products
      var validationResponse = await ApiService().validateCartProducts(context, cartproducts);
      if (validationResponse.toString() == "Le panier est valide") {
        // Step 2: Get payment intent from Stripe
        var paymentIntentResponse = await ApiService().getPaymentIntent(ApiService.finalAmount, ApiService.currency);
        await ApiService().initPaymentSheet(paymentIntentResponse);

        // Step 3: Present the payment sheet
        await Stripe.instance.presentPaymentSheet();

        // Step 4: If payment is successful, create the command
        Command? commandSuccessDTO = await ApiService().CreateCommand(commandDTO);
        ApiService.CartItemCount = 0;

        if (commandSuccessDTO != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              //builder: (context) => OrderSuccessPage(commandSuccessDTO: commandSuccessDTO),
              builder: (context) => OrderSuccessPage(sessionId: '',),
            ),
          );
        }
      }
    } catch (e) {
      // Handle any errors (e.g., payment sheet dismissed by user)
      print("Payment error: $e");

    }
  }

  Future<Map<String, dynamic>> getPaymentIntent(double totalPrice, String currency) async {
    String? token = await FirebaseMessaging.instance.getToken();
    List<String> tokens = [""];
    tokens.add(token!);
    CommandDTO commandDTO = CommandDTO(address, currency, totalPrice, phoneNum, tokens);
    //dio.options.headers['Authorization'] = 'Bearer ${StripeService.secretKey}';
    var response = await _dio.post('/api/Stripe/CreatePaymentIntent', data: commandDTO.toJson());
    return response.data;
  }

  Future<void> initPaymentSheet(data) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Lapin Couvert',
          paymentIntentClientSecret: data['clientSecret'],
          customerId: data['customer'],
          googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'CA', testEnv: true),
          applePay: const PaymentSheetApplePay(merchantCountryCode: 'CA'),
        ),
      );
    } catch (e) {
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      rethrow;
    }
  }

  Future<void> processPayment() async {
    try {
      var data = await getPaymentIntent(ApiService.finalAmount, currency);
      await initPaymentSheet(data);
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      rethrow;
    }
  }

  Future<List<Command>> getMyDeliveries() async {

    List<Command> listCommand = [];

    try{
      var response = await _dio.get('/api/Commands/GetMyDeliveries');
      if(response.statusCode == 200){
        List<dynamic> data = response.data;
        listCommand = data.map((json) => Command.fromJson(json)).toList();
        return listCommand;
      }

    }catch(e){
      throw Exception();
    }

    return listCommand;
  }

  Future<void> assignADelivery (int commandId) async{
    try{
      var response = await _dio.get('/api/Commands/AssignADelivery/' + commandId.toString());
      print(response.data);
      return response.data;
    }on DioException catch(e){
      throw Exception();
    }
  }

  Future<void> cancelADelivery (int commandId) async{
    try{
      var response = await _dio.get('/api/Commands/CancelADelivery/' + commandId.toString());
      print(response.data);
      return response.data;
    }on DioException catch(e){
      throw Exception();
    }
  }

  double calculateFinalTotal(List<CartProductDTO> cartProduct){
    double price = 0;
    cartProduct.forEach( (element) {
      price += calculateSubTotal(element);
    });
    finalAmount = double.parse((price * 1.15).toStringAsFixed(2));
    return finalAmount;
  }

  double calculateSubTotal(CartProductDTO cartProduct){
    double price = cartProduct.quantity * cartProduct.prix;
    return price;
  }


  Future<ProfileDTO?> getProfileInfo() async {
    try {
      var response = await _dio.get('/api/Account/GetProfileInfo');
      ProfileDTO? profile = ProfileDTO.fromJson(response.data);
      return profile;
    } catch (e) {
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      //rethrow;
      return null;
    }
  }

  Future<ProfileDTO> updateProfile(ProfileModificationDTO profileData,File? imageFile, BuildContext context) async {

    try {
      if(imageFile != null){
        await uploadImage(imageFile, context);
      }
      var response = await _dio.post('/api/Account/ModifyProfile', data: profileData); // Backend API endpoint

      ProfileDTO profile = ProfileDTO.fromJson(response.data);
      return profile;

    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<void> uploadImage(File imageFile, BuildContext context) async {

    try{
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path),
      });

      final response = await _dio.post('/api/Account/ModifyImage',
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );
    } on DioException catch(e){
      if(e.type == DioExceptionType.badResponse){
        showErrorMessage(context, 'Oups l\'upload n\'a pas marché');
      }
    }
  }
  Future<List<SuggestedProductDTO>> getSuggestedProducts() async {
    try {
      // Note: the endpoint is relative to baseUrl.
      final response = await _dio.get('/api/SuggestedProducts/GetSuggestedProducts');
      List<dynamic> data = response.data;
      return data.map((json) => SuggestedProductDTO.fromJson(json)).toList();
    } on DioException catch (e) {
      print("Error getting suggested products: $e");
      throw e;
    }
  }
  Future<void> voteFor(int suggestedProductId) async {
    try {
      await _dio.post(
        '/api/SuggestedProducts/VoteFor/${suggestedProductId}',
      );
    } on DioException catch (e) {
      print("Error posting vote: $e");
      throw e;
    }
  }
  Future<void> voteAgainst(int suggestedProductId) async {
    try {
      await _dio.post(
        '/api/SuggestedProducts/VoteAgainst/${suggestedProductId}',
      );
    } on DioException catch (e) {
      print("Error posting vote: $e");
      throw e;
    }
  }


  /***
   * The following is my implementation of the chat functionnality bayybay
   */

  Future<void> markCommandInProgress(int commandId) async {
    try {
      final response = await _dio.get('/api/Commands/DeliveryInProgress/$commandId');

      if (response.statusCode == 200) {
        // When command is marked in progress, initialize the chat
        final currentUserId = ApiService.clientId;

        // We need to retrieve the command to get client and delivery person IDs
        final command = await getCommandById(commandId);

        if (command != null) {
          final ChatService chatService = ChatService();

          // Create or activate chat
          await chatService.createChat(
            commandId,
            command.clientId,
            command.deliveryManId ?? currentUserId,
          );
        }
      }
    } catch (e) {
      print('Failed to mark command in progress: $e');
      throw Exception('Failed to mark command in progress: $e');
    }
  }

// New method to get a specific command by ID
  Future<Command?> getCommandById(int commandId) async {
    try {
      final response = await _dio.get('/api/Commands/GetCommand/$commandId');

      if (response.statusCode == 200) {
        return Command.fromJson(response.data);
      }
    } catch (e) {
      print('Failed to get command: $e');
    }
    return null;
  }

// Helper method to end chat when a delivery is completed
  Future<void> commandDelivered(int commandId) async {
    try {
      final response = await _dio.get('/api/Commands/CommandDelivered/$commandId');

      if (response.statusCode == 200) {
        // End the chat when delivery is complete
        try {
          final ChatService chatService = ChatService();
          await chatService.endChat(commandId);
        } catch (e) {
          print('Error ending chat: $e');
        }
      }
    } catch (e) {
      print('Failed to mark as delivered: $e');
      throw Exception('Failed to mark as delivered: $e');
    }
  }

  // Helper method to end chat when a delivery is completed
  Future<void> endChatOnDeliveryComplete(int commandId) async {
    try {
      final ChatService chatService = ChatService();
      await chatService.endChat(commandId);
    } catch (e) {
      print('Failed to end chat: $e');
    }
  }
  // Add these methods to your ApiService class

  Future<String> getAuthToken() async {
    return await AuthService.getToken() ?? '';
  }

  Future<bool> verifyStripePaymentStatus(String sessionId) async {
    try {
      var response = await _dio.get('/api/Stripe/VerifyPayment/$sessionId');

      if (response.statusCode == 200) {
        // Check the payment status from the response
        final status = response.data['paymentStatus'];
        return status == 'paid' || status == 'complete';
      }
      return false;
    } on DioException catch (e) {
      print('Failed to verify payment: $e');
      return false;
    }
  }

// Add this to handle web-specific payment flow
  Future<void> processWebPayment(BuildContext context, List<CartProductDTO> cartProducts) async {
    try {
      // Step 1: Validate cart products
      var validationResponse = await validateCartProducts(context, cartProducts);

      if (validationResponse.toString() == "Le panier est valide") {
        // Step 2: Create a Stripe checkout session
        String? token = await FirebaseMessaging.instance.getToken();
        List<String> tokens = token != null ? [token] : [];

        CommandDTO commandDTO = CommandDTO(
            address,
            currency,
            finalAmount,
            phoneNum,
            tokens
        );

        // Create a checkout session
        var sessionResponse = await _dio.post(
          '/api/Stripe/CreateCheckoutSession',
          data: commandDTO.toJson(),
        );

        if (sessionResponse.statusCode == 200) {
          // Get checkout URL from response
          final sessionId = sessionResponse.data['id'];
          final checkoutUrl = sessionResponse.data['url'];

          // Open the checkout URL in a new tab
          if (kIsWeb) {
            html.window.open(checkoutUrl, '_blank');
          }
          // Store the session ID for later verification
          // You can save this to local storage or pass it to the success page
          LocalStorageService.saveSessionId(sessionId);
        }
      }
    } catch (e) {
      print("Web payment initialization error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initialize payment: $e')),
      );
    }
  }

  // Add these methods to your ApiService class

  Future<Command?> verifyPaymentAndCreateCommand(String sessionId) async {
    try {
      // Show debug info
      print("Verifying payment with session ID: $sessionId");

      // Make sure we have a valid token
      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      // Set up request headers
      _dio.options.headers['Authorization'] = 'Bearer $token';

      // Call API to verify checkout session and create command
      final response = await _dio.get(
        '/api/Stripe/VerifyCheckoutSession/$sessionId',
      );

      print("Verify checkout response: ${response.data}");

      // Check response status
      if (response.statusCode == 200) {
        print("Payment verified and command created successfully");
        return Command.fromJson(response.data);
      } else {
        throw Exception('Payment verification failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Payment verification error: $e');

      // More detailed error logging
      if (e is DioException && e.response != null) {
        print('Response status: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }

      throw e; // Re-throw to be handled by the caller
    }
  }

// For debugging purposes, let's add a method to print API endpoint details
  void printApiEndpoints() {
    print("API Base URL: $BaseUrl");
    print("Available endpoints:");
    print("- Create Checkout Session: $BaseUrl/api/Stripe/CreateCheckoutSession");
    print("- Verify Payment: $BaseUrl/api/Stripe/VerifyPayment/{sessionId}");
  }
}

