import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/app_constant.dart';
import 'package:register_visa_web_app/core/constants/app_text_style.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/router/router_names.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/auth/providers/auth_provider.dart';
import 'package:register_visa_web_app/shared/services/storage_services.dart';

class BuildUserView extends ConsumerWidget {
  const BuildUserView({super.key, required this.isSmallScreen});

  final bool isSmallScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      position: PopupMenuPosition.under,
      padding: EdgeInsetsGeometry.only(top: 50),
      onSelected: (value) async {
        if (value == 'profile') {
          context.go(RouterNames.profile);
        } else if (value == 'settings') {
          context.go(RouterNames.visaPage);
        } else if (value == 'logout') {
          print("AUTH TOKEN ${AppConstants.authToken}");
          //* Logout procedure: clear login status and remove user data, then navigate to home
          await HiveService.setLogin(false); //* Mark user as logged out
          await HiveService.deleteUser(); //* Delete user info from persistent storage
          AppConstants.authToken = "";
          ref.read(loginProvider.notifier).logout(); //* Reset login state
          if (context.mounted) {
            context.go(RouterNames.home); //* Redirect to home page after logout
          }
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.person), // Add an icon for Profile
              SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  'Profile',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontFamily: FontFamily.outfitSemiBold,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings), // Add an icon for Settings
              SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  'Settings',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontFamily: FontFamily.outfitSemiBold,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout), // Add an icon for Log Out
              SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  'Log Out',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontFamily: FontFamily.outfitSemiBold,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      child: ProfileAvatar(
        size: 44,
        imageUrl: HiveService.getProfile(),
        userName: HiveService.getUserName().toString(),
      ), // Placeholder for user icon/avatar
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.size = 40,
    this.imageUrl,
    required this.userName,
  });

  final double size;
  final String? imageUrl;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: AppColors.primaryBlue,
      child: hasImage
          ? ClipOval(
              child: Image.network(
                imageUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _initials(),
              ),
            )
          : _initials(),
    );
  }

  Widget _initials() {
    return Text(
      _getInitials(userName),
      style: AppTextStyle.outFitSemiBoldStyle.copyWith(
        color: AppColors.lightBackground,
        fontSize: size * 0.35,
      ),
    );
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return '';

    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first[0].toUpperCase();

    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
