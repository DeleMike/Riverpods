import 'dart:collection' show MapView;

import 'package:flutter/foundation.dart' show immutable;
import 'package:instant_gram/state/constants/firebase_fields.dart';
import 'package:instant_gram/state/posts/typedefs/user_id.dart';

@immutable
class UserInfoPayload extends MapView<String, String> {
  UserInfoPayload(
      {required UserId userId, required String? displayName, String? email})
      : super(
          {
            FirebaseFieldName.userId: userId,
            FirebaseFieldName.displayName: displayName ?? '',
            FirebaseFieldName.email: email ?? '',
          },
        ); // serialize the userinfo payload to map object
}
