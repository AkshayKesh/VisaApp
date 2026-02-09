import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/evisa_application/providers/evisa_application_provider.dart';
import 'package:register_visa_web_app/features/evisa_application/providers/evisa_application_state.dart';

class StepPassportDetails extends ConsumerWidget {
  const StepPassportDetails({super.key, this.applicantIndex = 0});

  final int applicantIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(evisaApplicationProvider);
    final photoUrl = state.applicantPhotoUrlByIndex.length > applicantIndex ? state.applicantPhotoUrlByIndex[applicantIndex] : null;
    final bio = state.passportBioByIndex.length > applicantIndex ? state.passportBioByIndex[applicantIndex] : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRow = constraints.maxWidth > 600;
        if (useRow) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ApplicantPhotoSection(applicantPhotoUrl: photoUrl),
              const SizedBox(width: 32),
              Expanded(child: _PassportBioSection(bio: bio)),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _ApplicantPhotoSection(applicantPhotoUrl: photoUrl),
            24.ht,
            _PassportBioSection(bio: bio),
          ],
        );
      },
    );
  }
}

class _ApplicantPhotoSection extends StatelessWidget {
  final String? applicantPhotoUrl;

  const _ApplicantPhotoSection({this.applicantPhotoUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Applicant's Photo",
          style: context.titleSmall?.copyWith(fontSize: 14, fontFamily: FontFamily.outfitSemiBold, color: AppColors.darkTextColor),
        ),
        12.ht,
        Container(
          width: 220,
          height: 260,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.textFieldBorderColor),
            color: Colors.grey.shade200,
          ),
          clipBehavior: Clip.antiAlias,
          child: applicantPhotoUrl != null && applicantPhotoUrl!.isNotEmpty
              ? Image.network(
                  applicantPhotoUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) => progress == null
                      ? child
                      : Center(
                          child: CircularProgressIndicator(
                            value: progress.expectedTotalBytes != null ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes! : null,
                          ),
                        ),
                  errorBuilder: (_, __, ___) => Center(child: Icon(Icons.broken_image_outlined, size: 48, color: AppColors.lightSubText)),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, size: 64, color: AppColors.lightGrey150),
                    8.ht,
                    Text(
                      'No photo uploaded',
                      style: context.bodySmall?.copyWith(fontFamily: FontFamily.outfitRegular, color: AppColors.lightSubText),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _PassportBioSection extends StatelessWidget {
  final PassportBioData? bio;

  const _PassportBioSection({required this.bio});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Passport Bio',
          style: context.titleSmall?.copyWith(fontSize: 14, fontFamily: FontFamily.outfitSemiBold, color: AppColors.darkTextColor),
        ),
        12.ht,
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.textFieldBorderColor),
            color: AppColors.lightGrey100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DetailRow(label: 'First Name', value: bio?.firstName ?? '—'),
              12.ht,
              _DetailRow(label: 'Last Name', value: bio?.lastName ?? '—'),
              12.ht,
              _DetailRow(label: 'Issue Country', value: bio?.issueCountry ?? '—'),
              12.ht,
              _DetailRow(label: 'Passport Number', value: bio?.number ?? '—'),
              12.ht,
              _DetailRow(
                label: 'Passport Expiry Date',
                value: (bio?.expiryMonth != null && bio?.expiryDay != null && bio?.expiryYear != null)
                    ? '${bio?.expiryMonth} ${bio?.expiryDay}, ${bio?.expiryYear}'
                    : (bio?.expiryDate ?? '—'),
              ),
            ],
          ),
        ),
        24.ht,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _PassportScanThumb(label: 'Passport - Front', imageUrl: bio?.frontImageUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _PassportScanThumb(label: 'Passport - Back', imageUrl: bio?.backImageUrl),
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: context.bodySmall?.copyWith(fontFamily: FontFamily.outfitRegular, color: AppColors.lightSubText, fontSize: 13),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.bodyMedium?.copyWith(fontFamily: FontFamily.outfitMedium, color: AppColors.darkTextColor),
          ),
        ),
      ],
    );
  }
}

class _PassportScanThumb extends StatelessWidget {
  final String label;
  final String? imageUrl;

  const _PassportScanThumb({required this.label, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: context.titleSmall?.copyWith(fontSize: 13, fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
        ),
        8.ht,
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.textFieldBorderColor),
            color: Colors.grey.shade200,
          ),
          clipBehavior: Clip.antiAlias,
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) => progress == null
                      ? child
                      : Center(
                          child: CircularProgressIndicator(
                            value: progress.expectedTotalBytes != null ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes! : null,
                          ),
                        ),
                  errorBuilder: (_, __, ___) => Center(child: Icon(Icons.broken_image_outlined, size: 32, color: AppColors.lightSubText)),
                )
              : Center(child: Icon(Icons.document_scanner_outlined, size: 32, color: AppColors.lightSubText)),
        ),
      ],
    );
  }
}
