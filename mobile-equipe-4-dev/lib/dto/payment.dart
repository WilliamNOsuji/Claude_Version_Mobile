import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
///
/// Command: flutter pub run build_runner build
part 'payment.g.dart';


// TODO : Adding an Address DTO containing the City, Country, Postal Code, Provice/State, Line/Road
// TODO :

@JsonSerializable()
class PaymentIntentDTO {
  PaymentIntentDTO(this.clientSecret, this.customer);

  String clientSecret;
  String customer;

  factory PaymentIntentDTO.fromJson(Map<String, dynamic> json) => _$PaymentIntentDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentIntentDTOToJson(this);
}

@JsonSerializable()
class CustomerDTO {
  CustomerDTO(this.email, this.firstName, this.lastName);

  String email;
  String firstName;
  String lastName;

  factory CustomerDTO.fromJson(Map<String, dynamic> json) => _$CustomerDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerDTOToJson(this);
}

@JsonSerializable()
class PaymentInfoDTO {
  PaymentInfoDTO(this.amount, this.cardNumber, this.cvcNumber, this.expirationDate);

  double amount;
  String cardNumber;
  int cvcNumber;
  DateTime expirationDate;

  factory PaymentInfoDTO.fromJson(Map<String, dynamic> json) => _$PaymentInfoDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentInfoDTOToJson(this);
}

@JsonSerializable()
class CommandDTO {
  CommandDTO(this.address, this.currency,  this.totalPrice,  this.phoneNumber, this.deviceTokens);

  double totalPrice;
  String currency;
  String address;
  String phoneNumber;
  List<String> deviceTokens;

  factory CommandDTO.fromJson(Map<String, dynamic> json) => _$CommandDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CommandDTOToJson(this);
}

@JsonSerializable()
class DeliveryManDTO {
  DeliveryManDTO(this.username, this.fullName);

  String username;
  String fullName;


  factory DeliveryManDTO.fromJson(Map<String, dynamic> json) => _$DeliveryManDTOFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryManDTOToJson(this);
}

@JsonSerializable()
class CheckoutSessionRequest {
  CheckoutSessionRequest(this.totalPrice, this.currency, this.address, this.phoneNumber, this.deviceTokens, this.successUrl, this.cancelUrl);

  double totalPrice;
  String currency;
  String address;
  String phoneNumber;
  List<String> deviceTokens;
  String successUrl;
  String cancelUrl;

  factory CheckoutSessionRequest.fromJson(Map<String, dynamic> json) => _$CheckoutSessionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutSessionRequestToJson(this);
}

@JsonSerializable()
class Command{
  Command(this.id, this.commandNumber,this.clientPhoneNumber,this.arrivalPoint,this.totalPrice,this.currency,this.isDelivered, this.isInProgress,this.clientId, this.deliveryManId);

  int id;
  int commandNumber;
  String clientPhoneNumber;
  String arrivalPoint;
  double totalPrice;
  String currency;
  bool isDelivered;
  bool isInProgress;
  int clientId;
  int? deliveryManId;

  factory Command.fromJson(Map<String, dynamic> json) => _$CommandFromJson(json);

  Map<String, dynamic> toJson() => _$CommandToJson(this);
}