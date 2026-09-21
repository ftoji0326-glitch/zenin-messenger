import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../services/auth_storage.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'splash_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _api = ApiService();
  final _storage = AuthStorage();
  Widget? _destination;

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final token = await _storage.readToken();
    if (!mounted) return;

    if (token == null || token.isEmpty) {
      setState(() => _destination = const LoginScreen());
      return;
    }

    _api.setToken(token);
    try {
      final profile = await _api.fetchProfile();
      final chats = await _api.fetchChats();
      if (!mounted) return;
      setState(() => _destination = HomeScreen(
            api: _api,
            storage: _storage,
            profile: profile,
            chats: chats,
          ));
    } catch (_) {
      await _storage.clearToken();
      _api.setToken(null);
      if (mounted) setState(() => _destination = const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: _destination ?? const SplashScreen(),
    );
  }
}
