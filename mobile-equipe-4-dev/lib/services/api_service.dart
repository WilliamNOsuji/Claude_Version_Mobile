import 'dart:io';
import 'dart:ui';

import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobilelapincouvert/dto/vote.dart';

import '../dto/auth.dart';
import '../dto/payment.dart';
import '../dto/product.dart';
import '../gestion_erreurs.dart';
import '../main.dart';
import '../pages/clientOrderPages/orderHistoryPage.dart';
import '../pages/paymentProcessPages/order_success_page.dart';
import 'chat_service.dart';
import 'auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'local_storage_stripe_service.dart';

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
      baseUrl:   BaseUrl,
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
          if (error.response?.statusCode == 401) {
            _redirectToLogin();
          }
          return handler.next(error);
        },
      ),
    );
  }

  void _redirectToLogin() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/loginPage', // Or whatever your login route is
          (route) => false, // Remove all back stack
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
        if (response.data.toString() != 'Produit existe déjà') {
          setState(() {
            ApiService.CartItemCount++;
          });
        }
        return response.data.toString(); // Successful response
      } else {
        return 'Erreur du serveur';
      }
    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse){
        return e.response.toString();
      }

      return 'Erreur de connexion au serveur';
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

//region Paiment Stripe Web & Mobile

  //region Stripe Mobile

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

  //endregion

  //region Stripe Web

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

        try{
          // Step 3: Present the payment sheet
          var response = await Stripe.instance.presentPaymentSheet();
          print(response);
        }catch(e){
          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : Instance de la feuille de transaction à échouée')));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Le processus de paiement a été annulé.')));
          rethrow;
        }

        try{
          // Step 4: If payment is successful, create the command
          Command? commandSuccessDTO = await ApiService().CreateCommand(commandDTO);
          ApiService.CartItemCount = 0;
          if (commandSuccessDTO != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                // CommandSuccessDTO was being passed as a parameter
                builder: (context) => OrderSuccessPage(sessionId: '',),
              ),
            );
          }
        }catch(e){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : Création lors de la commande')));
        }
      }
    } on StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Le processus de paiement a été annulé.")));
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPaymentIntent(double totalPrice, String currency) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      List<String> tokens = [""];
      tokens.add(token!);
      CommandDTO commandDTO = CommandDTO(
          address, currency, totalPrice, phoneNum, tokens);
      //dio.options.headers['Authorization'] = 'Bearer ${StripeService.secretKey}';
      var response = await _dio.post(
          '/api/Stripe/CreatePaymentIntent', data: commandDTO.toJson());
      return response.data;
    } catch (e) {
      throw Exception();
    }
  }

  Future<bool> verifyStripePaymentStatus(String sessionId) async {
    try {
      var response = await _dio.get('/api/Stripe/VerifyCheckoutSession/$sessionId');

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

  Future<Command?> verifyPaymentAndCreateCommand(String sessionId) async {
    try {
      // Get token from persistent storage
      final token = await AuthService.getToken();
      if (token == null) {
        print('Authentication token not found for payment verification');
        throw Exception('Authentication token not found. Please log in again.');
      }

      // Set up request headers
      _dio.options.headers['Authorization'] = 'Bearer $token';

      // Log request details
      print('Verifying payment session: $sessionId');
      print('Using API endpoint: $BaseUrl/api/Stripe/VerifyCheckoutSession/$sessionId');

      // Call API to verify checkout session and create command
      final response = await _dio.get(
        '/api/Stripe/VerifyCheckoutSession/$sessionId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) {
            return status! < 500; // Accept all responses below 500 to handle server errors
          },
        ),
      );

      // Log the response
      print('Payment verification response status: ${response.statusCode}');
      print('Payment verification response data: ${response.data}');

      // Check if the response is successful
      if (response.statusCode == 200) {
        try {
          // Try to parse the command from the response
          final command = Command.fromJson(response.data);

          // Update cart count after successful order
          ApiService.CartItemCount = 0;

          return command;
        } catch (parseError) {
          print('Error parsing command from response: $parseError');
          throw Exception('Invalid response format from server');
        }
      } else if (response.statusCode == 401) {
        // Handle authentication errors
        print('Authentication failed during payment verification');
        throw Exception('Authentication expired. Please log in again.');
      } else {
        // Handle other error responses
        String errorMessage = 'Payment verification failed';
        if (response.data is Map && response.data['message'] != null) {
          errorMessage = response.data['message'];
        }
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      print('DioException during payment verification: ${e.message}');

      if (e.type == DioExceptionType.connectionError) {
        throw Exception('Connection error. Please check your internet connection.');
      } else if (e.response != null) {
        print('Error response status: ${e.response?.statusCode}');
        print('Error response data: ${e.response?.data}');

        if (e.response?.statusCode == 401) {
          throw Exception('Your session has expired. Please log in again.');
        } else {
          String errorMsg = 'Server error';
          if (e.response?.data is Map && e.response?.data['message'] != null) {
            errorMsg = e.response?.data['message'];
          }
          throw Exception(errorMsg);
        }
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      // Handle all other errors
      print('Error during payment verification: $e');
      throw Exception('Error verifying payment: $e');
    }
  }

  //endregion

//endregion

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

  Future<ProfileDTO> updateProfileWeb(ProfileModificationDTO profileData,XFile? imageFile, BuildContext context) async {

    try {
      if(imageFile != null){
        await uploadImageWeb(imageFile);
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

  Future<void> uploadImageWeb(XFile image) async {

    // Convert XFile to Uint8List
    Uint8List imageBytes = await image.readAsBytes();

    // Get MIME type of the file
    String? mimeType = lookupMimeType(image.name);

    // Create MultipartFile from bytes (No need for File)
    MultipartFile multipartFile = MultipartFile.fromBytes(
      imageBytes,
      filename: image.name,  // Set filename
      contentType: mimeType != null ? MediaType.parse(mimeType) : null,
    );

    // Create FormData
    FormData formData = FormData.fromMap({
      "file": multipartFile,
    });

    try {
      final response = await _dio.post(
        '/api/Account/ModifyImage',
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Upload successful');
      } else {
        print('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
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


}

