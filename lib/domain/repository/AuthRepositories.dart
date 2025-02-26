import 'package:flutter/foundation.dart';
import 'package:smart_mobile_app/domain/entity/responses/get_all_tasks_reponse.dart';

import '../../core/network/api_client.dart';

abstract class AuthRepository {
  Future<String> login(String email, String password);
  Future<String> register(String name, String email, String password);
  Future<void> sendFcmToken(String fcmToken);
}
