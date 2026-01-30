// lib/data/dummy_users.dart

enum Role {
  admin,
  petugas,
  peminjam,
}

class DummyUser {
  final String email;
  final String password;
  final Role role;

  DummyUser({
    required this.email,
    required this.password,
    required this.role,
  });
}

/// ⚠️ INI PENGGANTI DATABASE (SEMENTARA)
/// TIDAK PERLU UBAH KODE LOGIN / UI
final List<DummyUser> dummyUsers = [
  DummyUser(
    email: 'chellaa@gmail.com',
    password: '123',
    role: Role.admin,
  ),
  DummyUser(
    email: 'rotul@gmail.com',
    password: '123',
    role: Role.petugas,
  ),
  DummyUser(
    email: 'andi@gmail.com',
    password: '123',
    role: Role.peminjam,
  ),
];
