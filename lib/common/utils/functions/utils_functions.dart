
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_mobile_app/core/services/app_local_storage%20services.dart';
import 'package:smart_mobile_app/dependency_injection.dart';
import 'package:smart_mobile_app/domain/entity/responses/create_task_response.dart';
import 'package:intl/intl.dart';
import 'package:smart_mobile_app/presentation/providers/auth_provider.dart';

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  return DateFormat('dd-MM-yyyy').format(dateTime);
}

String formatAddTaskDate(DateTime dateString) {
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateString);

}
List<String> getUserInitials(List<TaskUsers> users) {
  return users.map((user) {
    List<String> nameParts = user.name.split(' ');
    return nameParts.map((part) => part[0]).join().toUpperCase();
  }).toList();
}

String getUserNameInitials(String name) {
  List<String> names = name.split(' ');
  String initials = "";
  if (names.isNotEmpty) initials += names[0][0].toUpperCase();
  if (names.length > 1) initials += names[1][0].toUpperCase();
  return initials;
}

String capitalizeEachWord(String text) {
  return text.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1);
  }).join(' ');
}

Future<String?> getFcmToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    String? token = await messaging.getToken();
    return token;
  } else {
    print("User declined or has not accepted permission");
    return null;
  }
}

Future<void> getToken() async {
  try {
    final token = await getFcmToken();

    if (token == null) {
      if (kDebugMode) {
        print("FCM Token is null, skipping update.");
      }
      return;
    }

    if (kDebugMode) {
      print("FCM Token: $token");
    }

    final storageService = getIt<SmartLocalStorageServices>();
    final storedFcmToken = await storageService.getData('firebaseToken');

    if (token == storedFcmToken) {
      if (kDebugMode) {
        print("FCM Token is already up to date, no API call needed.");
      }
      return;
    }

    final authProvider = getIt<AuthProvider>();
    await authProvider.sendFcmToken(token);
    await storageService.setFirbaseToken(token);

    if (kDebugMode) print("FCM Token updated successfully.");
  } catch (e) {
    if (kDebugMode) print("Error fetching FCM Token: $e");
  }
}
