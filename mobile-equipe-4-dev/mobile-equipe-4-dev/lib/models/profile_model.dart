import 'dart:io';

class Profile {
  final String? firstName;
  final String? lastName;
  final String? newPassword;
  final String? oldPassword;
  final File? profilePicture; // Optional, for handling file uploads

  // Constructor with named parameters
  Profile({
    this.firstName,
    this.lastName,
    this.newPassword,
    this.oldPassword,
    this.profilePicture,
  });

  // Factory method to create a Profile from JSON
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      firstName: json['firstName'],
      lastName: json['lastName'],
      newPassword: json['newPassword'],
      oldPassword: json['oldPassword'],
      profilePicture: json['profilePicture'] != null ? File(json['profilePicture']) : null,
    );
  }

  // Convert a Profile to JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'newPassword': newPassword,
      'oldPassword' : oldPassword,
      'profilePicture': profilePicture?.path, // Save the file path or handle upload separately
    };
  }
}
