class User {
  static int _nextId = 1;
  final int id;
  final String name;
  final String email;

  User({required this.name, required this.email}) : id = _nextId++;
}

List<User> users = [
  User(name: "Luiz Felipe Vieira Soares", email: "luiz@exemplo.com"),
  User(name: "Gabriel Resende Spirlandelli", email: "gabriel@exemplo.com"),
  User(name: "Henrique Almeida Florentino", email: "henrique@exemplo.com"),
  User(name: "Felipe Avelino Pedaes", email: "felipe@exemplo.com"),
];
