import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/router/router_names.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/profile/presentation/profile/provider/profile_provider.dart';
import 'package:register_visa_web_app/shared/services/image_picker_service.dart';
import 'package:register_visa_web_app/shared/services/storage_services.dart';
import 'package:register_visa_web_app/shared/widgets/app_bar_widget.dart';
import 'package:register_visa_web_app/shared/widgets/app_text_field.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';
import 'package:register_visa_web_app/shared/widgets/image_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../auth/domain/user.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({super.key});

  @override
  ConsumerState<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final ImagePickerService _imagePickerService = ImagePickerService();

  @override
  void initState() {
    nameController.text = HiveService.getUserName() ?? "";
    emailController.text = HiveService.getEmail() ?? "";
    phoneController.text = HiveService.getPhoneNumber() ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);
    ref.listen(profileProvider, (previous, next) {
      if (next.success) {
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        // profileImage = "";
        // notifier.reset();
        context.pushReplacement(RouterNames.home);
      }
    });
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            CustomAppBar(),
            46.ht,
            Text("View Profile", style: context.bodyLarge?.copyWith(fontFamily: FontFamily.outfitSemiBold, fontSize: 26.0)),
            20.ht,
            Container(
              width: 60.w,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.lightGrey100),
              ),
              child: Column(
                children: [
                  Text(
                    'Profile Picture',
                    style: context.titleSmall?.copyWith(color: AppColors.darkBackground, fontFamily: FontFamily.outfitMedium), // Using extension
                  ),
                  10.ht,
                  // Profile Picture Upload Placeholder
                  GestureDetector(
                    onTap: () async {
                      final image = await _imagePickerService.pickImageFromGallery2();
                      if (image != null) {
                        notifier.updateProfileImage(image.path, image);
                      }
                      // try {
                      //   final image = await _imagePickerService.pickImageFromGallery2();
                      //
                      //   if (image != null) {
                      //     String selectedImage = await Utils.convertUint8ListToBase64DataUrl(XFile(image.path));
                      //     ref
                      //         .read(profileProvider.notifier)
                      //         .updateProfileImage(selectedImage, image);
                      //   }
                      // } catch (e) {}
                    },
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: AppColors.lightCard,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.lightGrey, width: 2),
                      ),
                      child: profileState.profileImage == null ||
                          profileState.profileImage!.isEmpty
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 30, color: AppColors.lightSubText),
                          8.ht,
                          Text('Add Photo', style: context.bodySmall?.copyWith(fontFamily: FontFamily.outfitMedium)),
                        ],
                      )
                          : ClipOval(
                        child: AppCacheNetworkImage(url: profileState.profileImage!, height: 120, width: 120, boxFit: BoxFit.cover),
                      ),
                    ),
                  ),

                  // Container(
                  //   height: 120,
                  //   width: 120,
                  //   decoration: BoxDecoration(
                  //     color: AppColors.lightCard, // Light grey background
                  //     shape: BoxShape.circle,
                  //     border: Border.all(color: AppColors.lightGrey, width: 2),
                  //   ),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Icon(
                  //         Icons.upload_file,
                  //         size: 30,
                  //         color: AppColors.lightSubText,
                  //       ),
                  //       8.ht,
                  //       Text(
                  //         'Upload Photo',
                  //         style: context.bodySmall?.copyWith(
                  //           fontFamily: FontFamily.outfitMedium,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  10.ht,
                  Text(
                    'Click or drag to upload',
                    style: context.bodySmall?.copyWith(color: AppColors.lightSubText, fontFamily: FontFamily.outfitRegular), // Using extension
                  ),
                  30.ht,
                  AppTextFormField(
                    title: 'Full Name',
                    hint: 'Enter your full name',
                    prefixIcon: Icons.person_outline,
                    controller: nameController,
                    // Placeholder controller
                    validator: (value) {
                      if (nameController.text.trim().isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                  ),
                  20.ht,
                  Row(
                    children: [
                      Expanded(
                        child: AppTextFormField(
                          title: 'Email',
                          hint: 'your.email@example.com',
                          isReadOnly: true,
                          prefixIcon: Icons.email_outlined,
                          controller: emailController,
                          // Placeholder controller
                          validator: (value) {
                            if (emailController.text.trim().isEmpty) {
                              return "Email is required";
                            }
                            return null;
                          },
                        ),
                      ),
                      20.wt,
                      Expanded(
                        child: AppTextFormField(
                          title: 'Phone Number',
                          hint: '+1(555) 000-0000',
                          prefixIcon: Icons.phone_outlined,
                          controller: phoneController,
                          // Placeholder controller
                          validator: (value) {
                            if (phoneController.text.trim().isEmpty) {
                              return "Phone Number is required";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  20.ht,
                  CustomIconButton(
                    buttonState: ref
                        .watch(profileProvider)
                        .isLoading,
                    text: "Update Account",
                    onPressed: () {
                      notifier.updateUser(
                        User(fullName: nameController.text, phone: phoneController.text),
                      );
                    },
                    width: 25.w,
                    textColor: AppColors.lightBackground,
                    height: 40,
                    borderRadius: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
