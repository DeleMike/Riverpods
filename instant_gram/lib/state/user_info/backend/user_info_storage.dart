import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instant_gram/state/constants/firebase_collection_name.dart';
import 'package:instant_gram/state/constants/firebase_fields.dart';
import 'package:instant_gram/state/user_info/models/user_info_payload.dart';

import '../../posts/typedefs/user_id.dart';

@immutable
class UserInfoStorage {
  const UserInfoStorage();

  Future<bool> saveUserInfoStorage({
    required UserId userId,
    required String displayName,
    required String? email,
  }) async {
    try {
      // first check if we have this user's info already
      final userInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .where(FirebaseFieldName.userId, isEqualTo: userId)
          .limit(1)
          .get();

      if (userInfo.docs.isNotEmpty) {
        await userInfo.docs.first.reference.update({
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email ?? '',
        });

        return true;
      }

      // we don't have this user, create a new user
      final payload = UserInfoPayload(
        userId: userId,
        displayName: displayName,
        email: email,
      );

      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .add(payload);

      return true;
    } catch (e) {
      return false;
    }
  }
}
