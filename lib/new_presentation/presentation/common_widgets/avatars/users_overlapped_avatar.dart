import 'package:flutter/material.dart';

class UserAvatars extends StatelessWidget {
  final List<String> userInitials;
  final double avatarRadius;
  final double overlapAmount;
  final Color avatarColor;
  final TextStyle textStyle;

  UserAvatars({
    required this.userInitials,
    this.avatarRadius = 20,
    this.overlapAmount = 15,
    this.avatarColor = Colors.blue,
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 14),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _buildAvatarList(),
    );
  }

  List<Widget> _buildAvatarList() {
    List<Widget> avatars = [];
    int maxVisibleAvatars = 5; // Always show 5
    int displayCount = userInitials.length > maxVisibleAvatars ? maxVisibleAvatars - 1 : userInitials.length;

    for (int i = 0; i < displayCount; i++) {
      avatars.add(
        Positioned(
          left: i * (avatarRadius * 2 - overlapAmount),
          child: CircleAvatar(
            radius: avatarRadius,
            backgroundColor: avatarColor,
            child: Text(
              userInitials[i],
              style: textStyle,
            ),
          ),
        ),
      );
    }

    // If more than 5 users, show "+X" indicator at position 5
    if (userInitials.length > maxVisibleAvatars) {
      avatars.add(
        Positioned(
          left: displayCount * (avatarRadius * 2 - overlapAmount),
          child: CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Colors.grey[300],
            child: Text(
              '+${userInitials.length - displayCount}',
              style: textStyle.copyWith(color: Colors.black),
            ),
          ),
        ),
      );
    }

    return avatars;
  }
}