import 'package:flutter/foundation.dart' show immutable;

import 'auth_result.dart';
import '../../posts/typedefs/user_id.dart';

@immutable
class AuthState {
  final AuthResult? authResult;
  final bool isLoading;
  final UserId? userId;

  const AuthState({
    required this.authResult,
    required this.isLoading,
    required this.userId,
  });

  const AuthState.unknown()
      : authResult = null,
        isLoading = false,
        userId = null;

  AuthState copiedWithIsLoading(bool isNowLoading) => AuthState(
        authResult: authResult,
        isLoading: isNowLoading,
        userId: userId,
      );

  @override
  bool operator ==(covariant AuthState other) =>
      identical(this, other) ||
      (authResult == other.authResult && isLoading == other.isLoading);

  @override
  int get hashCode => Object.hashAll([authResult, isLoading, userId]);
}
