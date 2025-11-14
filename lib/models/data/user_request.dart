class UserRequest {
  final String name;
  final String email;
  final String? password;

  UserRequest({
    required this.name,
    required this.email,
    this.password,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'name': name,
      'email': email,
    };

    // Só adiciona a senha se ela não for nula e não estiver vazia
    if (password != null && password!.isNotEmpty) {
      json['password'] = password;
    }

    return json;
  }
}