enum Role { admin, petugas, peminjam }

class User {
  final String email;
  final String password;
  final Role role;

  User({
    required this.email,
    required this.password,
    required this.role,
  });
}

// Dummy users (sementara tanpa database)
final List<User> dummyUsers = [
  User(email: 'chellaa@gmail.com', password: '123', role: Role.admin),
  User(email: 'rotul@gmail.com', password: '123', role: Role.petugas),
  User(email: 'andi@gmail.com', password: '123', role: Role.peminjam),
];
