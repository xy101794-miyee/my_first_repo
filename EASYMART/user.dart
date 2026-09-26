class AppUser {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role; // user, vendor, admin

  AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.role = 'user',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'role': role,
      };

  factory AppUser.fromMap(Map<String, dynamic> map) => AppUser(
        id: map['id'] ?? '',
        fullName: map['fullName'] ?? '',
        email: map['email'] ?? '',
        phone: map['phone'] ?? '',
        role: map['role'] ?? 'user',
      );
}
