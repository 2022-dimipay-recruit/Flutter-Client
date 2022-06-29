import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/question_controller.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:get/get.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';

enum FollowButtonType {
  follow,
  unfollow,
  none
}

extension FollowButtonTypeExtension on FollowButtonType {
  String get convertKor {
    switch (this) {
      case FollowButtonType.follow: return "팔로우";
      case FollowButtonType.unfollow: return "언팔로우";
      default: return "";
    }
  }

  IconData get convertIcon {
    switch (this) {
      case FollowButtonType.follow: return Icons.add_circle_outline_rounded;
      case FollowButtonType.unfollow: return Icons.remove_circle_outline_rounded;
      default: return Icons.circle;
    }
  }
}

extension FollowEnumExtension on bool {
  FollowButtonType get convertFollowButtonType {
    switch (this) {
      case true: return FollowButtonType.follow;
      case false: return FollowButtonType.unfollow;
      default: return FollowButtonType.none;
    }
  }
}


class FollowButton extends StatelessWidget {
  final Rx<FollowButtonType> btnType;
  final String userId;
  FollowButton({required this.btnType, required this.userId});

  @override
  Widget build(BuildContext context) {
    UserController _userController = Get.find<UserController>();

    return Obx(() => GestureDetector(
      onTap: () {
        if (btnType.value == FollowButtonType.follow) {
          _userController.followOtherUser(userId, QuestionType.personal, btnType);
        } else {
          _userController.unfollowOtherUser(userId, QuestionType.personal, btnType);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(btnType.value.convertIcon, color: grayOne, size: 16),
          SizedBox(width: 4),
          Text(btnType.value.convertKor, style: profileFollowBtn)
        ],
      ),
    ));
  }
}