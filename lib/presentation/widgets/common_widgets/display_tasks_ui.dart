import 'package:flutter/material.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_fonts/app_fonts.dart';
import 'package:smart_mobile_app/common/utils/functions/utils_functions.dart';
import 'avatars/users_overlapped_avatar.dart';

class DisplayTasksUI extends StatelessWidget {
  final String title;
  final String description;
  final String urgencyLevel;
  final String deadline;
  final List<String> userInitials;
  final bool isEditing;
  final String editorName;

  const DisplayTasksUI({
    super.key,
    required this.title,
    required this.description,
    required this.urgencyLevel,
    required this.deadline,
    required this.userInitials,
    this.isEditing = false,
    this.editorName = '',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    capitalizeEachWord(title),
                    style: SmartTaskFonts.large().copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 5.0),
                  child: Text(
                    description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: SmartTaskFonts.small().copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    children: [
                      _buildTag(urgencyLevel),
                      SizedBox(width: 10),
                      _buildTag(formatDate(deadline)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 40,
                    child: UserAvatars(userInitials: userInitials),
                  ),
                ),
                if (isEditing)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 5.0, bottom: 10.0),
                    child: Text(
                      "$editorName is editing...",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
            Positioned(
              top: 20,
              right: 15,
              child: Icon(Icons.edit, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
        color: Colors.grey.withOpacity(0.2),
      ),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: SmartTaskFonts.small(),
      ),
    );
  }
}

