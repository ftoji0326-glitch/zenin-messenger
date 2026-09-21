class User {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
  });

  final String id;
  final String email;
  final String name;
  final String createdAt;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? 'Zenin user',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}

class Chat {
  const Chat({
    required this.id,
    required this.name,
    required this.participantIds,
    required this.createdAt,
    required this.lastMessageAt,
  });

  final String id;
  final String name;
  final List<String> participantIds;
  final String createdAt;
  final String? lastMessageAt;

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Untitled chat',
      participantIds: (json['participantIds'] as List<dynamic>? ?? [])
          .whereType<String>()
          .toList(),
      createdAt: json['createdAt'] as String? ?? '',
      lastMessageAt: json['lastMessageAt'] as String?,
    );
  }
}

class AuthSession {
  const AuthSession({required this.user, required this.token});

  final User user;
  final String token;

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      user: User.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      token: json['token'] as String? ?? '',
    );
  }
}
