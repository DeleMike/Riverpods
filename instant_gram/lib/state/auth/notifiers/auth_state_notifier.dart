import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/auth/backend/authenticator.dart';
import 'package:instant_gram/state/auth/models/auth_result.dart';
import 'package:instant_gram/state/auth/models/auth_state.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final _authenticator = const Authenticator();
  AuthStateNotifier() : super(const AuthState.unknown()) {
    if (_authenticator.isAlreadyLoggedIn) {
      state = AuthState(
        authResult: AuthResult.success,
        isLoading: false,
        userId: _authenticator.userId,
      );
    }
  }

  Future<void> logout() async {
    state = state.copiedWithIsLoading(true);
    await _authenticator.logout();
    state = const AuthState.unknown();
  }

  Future<void> login() async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator.loginWithGoogle();
    final userId = _authenticator.userId;
    if(result == AuthResult.success && userId != null) {
      
    }
  }
}
