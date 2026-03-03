/// Signup request model
class SignupRequest {
  final String email;
  final String password;
  final String fullName;
  final String? phoneNumber;

  SignupRequest({
    required this.email,
    required this.password,
    required this.fullName,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'full_name': fullName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
    };
  }
}
