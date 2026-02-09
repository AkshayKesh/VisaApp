import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/utils/utils.dart';
import 'package:register_visa_web_app/features/visa_process/controller/application_controller.dart';
import 'package:register_visa_web_app/features/visa_process/domain/traveller_model.dart';
import 'package:register_visa_web_app/features/visa_process/presentation/widget/passport_upload_card_videt.dart';
import 'package:register_visa_web_app/shared/services/image_picker_service.dart';

class PassportUploadSection extends StatelessWidget {
  final bool frontLoading;
  final bool backLoading;
  final Traveller traveller;
  final VisaApplicationController controller;
  final BuildContext context;

  const PassportUploadSection({
    super.key,
    required this.frontLoading,
    required this.backLoading,
    required this.traveller,
    required this.controller,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    screenSize = getSize(context);

    final cardHeight =
        (screenSize == ScreenSize.extraLarge || screenSize == ScreenSize.large)
        ? 200.0
        : 206.0;

    final frontCard = PassportUploadCard(
      isLoading: frontLoading,
      height: cardHeight,
      title: "Passport - Front Photo",
      subTitle: "Upload a clear scan of your passport photo page",
      imageUrl: traveller.passportFrontPhotoUrl,
      onTap: () async {
        final pickedFile = await ImagePickerService().pickImageFromGallery2();
        if (pickedFile != null) {
          controller.setPassportFrontPhoto(
            traveller.id,
            pickedFile.path,
            pickedFile,
          );
        }
      },
      onRemove: () => controller.removePhoto("front", traveller.id),
    );

    final backCard = PassportUploadCard(
      isLoading: backLoading,
      height: cardHeight,
      title: "Passport - Back Photo",
      subTitle: "Upload a recent passport-size photo",
      imageUrl: traveller.passportBackPhotoUrl,
      onTap: () async {
        final pickedFile = await ImagePickerService().pickImageFromGallery2();
        if (pickedFile != null) {
          controller.setPassportbackPhoto(
            traveller.id,
            pickedFile.path,
            pickedFile,
          );
        }
      },
      onRemove: () => controller.removePhoto("back", traveller.id),
    );

    /// 📱 MOBILE → Column
    if ((screenSize == ScreenSize.small || screenSize == ScreenSize.normal)) {
      return Column(
        children: [frontCard, const SizedBox(height: 16), backCard],
      );
    }

    /// 💻 TABLET & WEB → Row
    return Row(
      children: [
        Expanded(child: frontCard),
        const SizedBox(width: 24),
        Expanded(child: backCard),
      ],
    );
  }
}
