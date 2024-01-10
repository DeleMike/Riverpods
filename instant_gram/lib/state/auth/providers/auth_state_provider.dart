import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/auth/models/auth_state.dart';

import '../notifiers/auth_state_notifier.dart';

final authSateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(),
);
