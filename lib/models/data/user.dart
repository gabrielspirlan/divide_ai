class User {
  // static int _nextId = 1; // REMOVIDO: Não faremos mais auto-incremento local.
  final String id; // Alterado para String para corresponder à API
  final String name;
  final String email;
  // Nota: Password não é armazenado neste modelo de resposta.

  User({required this.id, required this.name, required this.email});

  // Factory para desserializar a resposta da API
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }
}

// REMOVIDO: A lista global de usuários 'users' deve ser removida ou adaptada.
// Caso necessite de dados de teste, eles devem ser inicializados com IDs String.
List<User> users = [
  User(id: "1", name: "Luiz Felipe Vieira Soares", email: "luiz@exemplo.com"),
  User(id: "2", name: "Gabriel Resende Spirlandelli", email: "gabriel@exemplo.com"),
  User(id: "3", name: "Henrique Almeida Florentino", email: "henrique@exemplo.com"),
  User(id: "4", name: "Felipe Avelino Pedaes", email: "felipe@exemplo.com"),
];