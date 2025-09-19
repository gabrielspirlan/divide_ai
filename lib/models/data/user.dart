class User {
  static int _nextId = 1;
  final int id;
  final String name;
  final String email;

  User({required this.name, required this.email}) : id = _nextId++;
}

List<User> users = [];
