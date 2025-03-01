
class RegisterDTO{
  final String username;
  final String matricule;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterDTO({
    required this.username,
    required this.matricule,
    required this.email,
    required this.password,
    required this.confirmPassword
  });

  // Convert the DTO to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'Username': username,
      'Matricule': matricule,
      'Email': email,
      'Password': password,
      'PasswordConfirm': confirmPassword,
    };
  }
}

class LoginDTO{
  int? matricule;
  String? password;
}