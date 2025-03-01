import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
///
/// Command: flutter pub run build_runner build
part 'auth.g.dart';


@JsonSerializable()
class SigninDTO {
  SigninDTO(this.username, this.password);

  String username;
  String password;

  factory SigninDTO.fromJson(Map<String, dynamic> json) => _$SigninDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SigninDTOToJson(this);
}

@JsonSerializable()
class SigninSuccessDTO {
  SigninSuccessDTO(this.token, this.clientId, this.clientName, this.isDeliveryMan, this.isActive);

  String token;
  int clientId;
  String clientName;
  bool isDeliveryMan;
  bool isActive;

  factory SigninSuccessDTO.fromJson(Map<String, dynamic> json) => _$SigninSuccessDTOFromJson(json);
  Map<String, dynamic> toJson() => _$SigninSuccessDTOToJson(this);
}


@JsonSerializable()
class RegisterDTO {
  RegisterDTO(this.username,this.firstName, this.lastName, this.email, this.password, this.passwordConfirm);

  String username;
  String firstName;
  String lastName;
  String email;
  String password;
  String passwordConfirm;

  factory RegisterDTO.fromJson(Map<String, dynamic> json) => _$RegisterDTOFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDTOToJson(this);
}

@JsonSerializable()
class CartProductDTO {
  CartProductDTO(
   this.id,
   this.cartId,
   this.productId,
   this.quantity,
   this.name,
   this.prix,
   this.imageUrl,
   this.maxQuantity,
   this.isOutofStock,
   this.isOutofBound   );

  int id;
  int cartId;
  int productId;
  int quantity;
  String name;
  double prix;
  String imageUrl;
  int maxQuantity;
  bool isOutofStock;
  bool isOutofBound;

  factory CartProductDTO.fromJson(Map<String, dynamic> json) => _$CartProductDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CartProductDTOToJson(this);
}

@JsonSerializable()
class ProfileDTO {
  ProfileDTO(
      this.userName,
      this.firstName,
      this.lastName,
      this.imgUrl,
      this.isDeliveryMan,
      this.isActiveAsDeliveryMan);

  String userName;
  String firstName;
  String lastName;
  String imgUrl;
  bool isDeliveryMan;
  bool isActiveAsDeliveryMan;

  factory ProfileDTO.fromJson(Map<String, dynamic> json) => _$ProfileDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDTOToJson(this);
}

@JsonSerializable()
class ProfileModificationDTO {
  ProfileModificationDTO(
      this.newFirstName,
      this.newLastName,
      this.newPassword,
      this.oldPassword);

  String? newFirstName;
  String? newLastName;
  String? newPassword;
  String? oldPassword;
  factory ProfileModificationDTO.fromJson(Map<String, dynamic> json) => _$ProfileModificationDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModificationDTOToJson(this);
}
