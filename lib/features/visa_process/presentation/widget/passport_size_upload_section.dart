import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/utils/utils.dart';
import 'package:register_visa_web_app/features/visa_process/controller/application_controller.dart';
import 'package:register_visa_web_app/features/visa_process/domain/traveller_model.dart';
import 'package:register_visa_web_app/features/visa_process/presentation/widget/passport_photo_instructions.dart';
import 'package:register_visa_web_app/features/visa_process/presentation/widget/passport_size_upload_card.dart';
import 'package:register_visa_web_app/features/visa_process/providers/application_state.dart';
import 'package:register_visa_web_app/shared/services/image_picker_service.dart';

class PassportSizeUploadSection extends StatelessWidget {
  final VisaApplicationState state;
  final VisaApplicationController controller;
  final Traveller traveller;

  const PassportSizeUploadSection({
    super.key,
    required this.state,
    required this.controller,
    required this.traveller,
  });

  @override
  Widget build(BuildContext context) {
    screenSize = getSize(context);

    final uploadCard = PassportSizeUploadCard(
      isLoading: state.passportPhotoLoading,
      imageUrl: traveller.passportPhotoUrl,
      height:
          (screenSize == ScreenSize.extraLarge ||
              screenSize == ScreenSize.large)
          ? 240
          : 260,
      width:
          (screenSize == ScreenSize.extraLarge ||
              screenSize == ScreenSize.large)
          ? 240
          : 340,
      onTap: () async {
        final pickedFile = await ImagePickerService().pickImageFromGallery2();
        if (pickedFile != null) {
          controller.setPassportSizePhoto(
            pickedFile.path,
            pickedFile,
            traveller.id,
          );
        }
      },
      onRemove: () => controller.removePhoto("photo", traveller.id),
    );

    /// 📱 MOBILE → Column
    if ((screenSize == ScreenSize.small || screenSize == ScreenSize.normal)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          uploadCard,
          const SizedBox(height: 16),
          const PassportPhotoInstructions(),
        ],
      );
    }

    /// 📱 TABLET & 💻 WEB → Row
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        uploadCard,
        const SizedBox(width: 32),
        Expanded(child: PassportPhotoInstructions()),
      ],
    );
  }
}
