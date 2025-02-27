import 'package:flutter_test/flutter_test.dart';
import 'package:smart_mobile_app/common/utils/functions/utils_functions.dart';
import 'package:smart_mobile_app/domain/entity/responses/create_task_response.dart';

void main() {
  group('Utility Functions Tests', () {
    test('formatDate should format date string correctly', () {
      String dateString = "2025-02-27T12:34:56Z";
      String formattedDate = formatDate(dateString);
      expect(formattedDate, equals("27-02-2025"));
    });

    test('formatAddTaskDate should format DateTime correctly', () {
      DateTime dateTime = DateTime(2025, 02, 27, 12, 34, 56);
      String formattedDate = formatAddTaskDate(dateTime);
      expect(formattedDate, equals("2025-02-27 12:34:56"));
    });

    test('getUserInitials should return initials for a list of users', () {
      List<TaskUsersMock> users = [
        TaskUsersMock(name: "John Doe"),
        TaskUsersMock(name: "Jane Smith"),
      ];
      List<String> initials = getUserInitialsTest(users);
      expect(initials, equals(["JD", "JS"]));
    });

    test('getUserNameInitials should return initials for a single user', () {
      String name = "John Doe";
      String initials = getUserNameInitials(name);
      expect(initials, equals("JD"));
    });

    test('capitalizeEachWord should capitalize each word in a string', () {
      String text = "hello world";
      String capitalizedText = capitalizeEachWord(text);
      expect(capitalizedText, equals("Hello World"));
    });


  });
}
