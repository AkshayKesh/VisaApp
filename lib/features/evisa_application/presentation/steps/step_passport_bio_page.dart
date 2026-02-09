import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:register_visa_web_app/core/constants/api_end_points.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/app_constant.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/string_logger_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/core/constants/country_list.dart';
import 'package:register_visa_web_app/core/utils/utils.dart';
import 'package:register_visa_web_app/features/evisa_application/providers/evisa_application_provider.dart';
import 'package:register_visa_web_app/features/evisa_application/providers/evisa_application_state.dart';
import 'package:register_visa_web_app/shared/services/dio_service.dart';
import 'package:register_visa_web_app/shared/services/image_picker_service.dart';
import 'package:register_visa_web_app/shared/widgets/app_drop_down.dart';
import 'package:register_visa_web_app/shared/widgets/image_view.dart';

class StepPassportBioPage extends ConsumerStatefulWidget {
  const StepPassportBioPage({
    super.key,
    this.applicantIndex = 0,
    this.applicationId,
  });

  final int applicantIndex;
  final String? applicationId;

  @override
  ConsumerState<StepPassportBioPage> createState() =>
      _StepPassportBioPageState();
}

class _StepPassportBioPageState extends ConsumerState<StepPassportBioPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passportNumberController = TextEditingController();
  String? _expiryMonth;
  String? _expiryDay;
  String? _expiryYear;
  String? _issueCountry;
  String? _frontImageUrl;
  String? _backImageUrl;
  Uint8List? _frontImageBytes;
  Uint8List? _backImageBytes;
  bool _frontLoading = false;
  bool _backLoading = false;

  Future<String?> _uploadPassportImage(XFile file) async {
    final bytes = await file.readAsBytes();
    final res = await ApiManager.multipartAPI(
      methodName: ApiEndpoints.uploadDocumentImage,
      params: {
        "image": dio.MultipartFile.fromBytes(bytes, filename: file.name),
      },
    );
    final data = res.data as Map<String, dynamic>?;
    if (data?["statusCode"] == 200) {
      return data?["data"]?["url"]?.toString();
    }
    return null;
  }

  Future<void> _pickFrontPhoto() async {
    setState(() => _frontLoading = true);
    try {
      final picked = await ImagePickerService().pickImageFromGallery2();
      if (picked != null && mounted) {
        final bytes = await picked.readAsBytes();
        final url = await _uploadPassportImage(picked);
        if (mounted && url != null && url.isNotEmpty) {
          setState(() {
            _frontImageUrl = url;
            _frontImageBytes = Uint8List.fromList(bytes);
          });
          _syncToState();
          debugPrint('Passport front photo URL: $url');
        }
      }
    } catch (_) {}
    if (mounted) setState(() => _frontLoading = false);
  }

  Future<void> _pickBackPhoto() async {
    setState(() => _backLoading = true);
    try {
      final picked = await ImagePickerService().pickImageFromGallery2();
      if (picked != null && mounted) {
        final bytes = await picked.readAsBytes();
        final url = await _uploadPassportImage(picked);
        if (mounted && url != null && url.isNotEmpty) {
          setState(() {
            _backImageUrl = url;
            _backImageBytes = Uint8List.fromList(bytes);
          });
          _syncToState();
          debugPrint('Passport back photo URL: $url');
        }
      }
    } catch (_) {}
    if (mounted) setState(() => _backLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_syncToState);
    _lastNameController.addListener(_syncToState);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = ref.read(evisaApplicationProvider);
      if (state.passportBioByIndex.length <= widget.applicantIndex) return;
      final bio = state.passportBioByIndex[widget.applicantIndex];
      "BIO $bio".logW();
      _firstNameController.removeListener(_syncToState);
      _lastNameController.removeListener(_syncToState);
      if (bio != null) {
        _firstNameController.text = bio.firstName ?? '';
        _lastNameController.text = bio.lastName ?? '';
        _passportNumberController.text = bio.number ?? '';
        _issueCountry = bio.issueCountry;
        _expiryMonth = bio.expiryMonth;
        _expiryDay = bio.expiryDay;
        _expiryYear = bio.expiryYear;
        _frontImageUrl = bio.frontImageUrl;
        _backImageUrl = bio.backImageUrl;
        _frontImageBytes = null;
        _backImageBytes = null;
      }
      if ((bio == null || (bio.firstName ?? '').trim().isEmpty) &&
          widget.applicationId != null &&
          widget.applicationId!.trim().isNotEmpty) {
        final appDetails = ref
            .read(applicationDetailsByIdProvider(widget.applicationId!.trim()))
            .value;
        if (appDetails != null &&
            widget.applicantIndex < appDetails.travellerDetails.length) {
          final t = appDetails.travellerDetails[widget.applicantIndex];
          "DDDD ${t.toJson()}".logW();
          if ((t.firstName ?? '').trim().isNotEmpty) {
            _firstNameController.text = t.firstName ?? '';
          }
          if ((t.lastName ?? '').trim().isNotEmpty) {
            _lastNameController.text = t.lastName ?? '';
          }
          if ((t.passportNumbe ?? '').trim().isNotEmpty) {
            _passportNumberController.text = t.passportNumbe ?? '';
          }
          if ((t.issueCountry ?? '').trim().isNotEmpty) {
            _issueCountry = t.issueCountry;
          }
          if ((t.expiryDay ?? '').trim().isNotEmpty) _expiryDay = t.expiryDay;
          if ((t.expiryMonth ?? '').trim().isNotEmpty) {
            _expiryMonth = Utils.getMonths(
              int.tryParse(t.expiryMonth ?? "0") ?? 0,
            );
          }
          if ((t.expiryYear ?? '').trim().isNotEmpty) {
            _expiryYear = t.expiryYear;
          }
        }
      }
      _firstNameController.addListener(_syncToState);
      _lastNameController.addListener(_syncToState);
      setState(() {});
    });
  }

  String? _resolveImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    final u = url.trim();
    if (u.startsWith('http://') || u.startsWith('https://')) return u;
    final base = ApiEndpoints.baseUrl;
    return u.startsWith('/') ? '$base$u' : '$base/$u';
  }

  @override
  void didUpdateWidget(StepPassportBioPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.applicantIndex != widget.applicantIndex ||
        oldWidget.applicationId != widget.applicationId) {
      final state = ref.read(evisaApplicationProvider);
      if (state.passportBioByIndex.length > widget.applicantIndex) {
        final bio = state.passportBioByIndex[widget.applicantIndex];
        if (bio != null) {
          setState(() {
            _firstNameController.text = bio.firstName ?? '';
            _lastNameController.text = bio.lastName ?? '';
            _passportNumberController.text = bio.number ?? '';
            _issueCountry = bio.issueCountry;
            _expiryMonth = bio.expiryMonth;
            _expiryDay = bio.expiryDay;
            _expiryYear = bio.expiryYear;
            _frontImageUrl = bio.frontImageUrl;
            _backImageUrl = bio.backImageUrl;
            _frontImageBytes = null;
            _backImageBytes = null;
          });
        } else if (widget.applicationId != null &&
            widget.applicationId!.trim().isNotEmpty) {
          final appDetails = ref
              .read(
                applicationDetailsByIdProvider(widget.applicationId!.trim()),
              )
              .value;
          if (appDetails != null &&
              widget.applicantIndex < appDetails.travellerDetails.length) {
            final t = appDetails.travellerDetails[widget.applicantIndex];
            setState(() {
              _firstNameController.text = t.firstName ?? '';
              _lastNameController.text = t.lastName ?? '';
              _passportNumberController.text = t.passportNumbe ?? '';
              if ((t.issueCountry ?? '').trim().isNotEmpty) {
                _issueCountry = t.issueCountry;
              }
              // if ((t.expiryDay ?? '').trim().isNotEmpty) {
              //   _expiryDay = t.expiryDay;
              // }
              // if ((t.expiryMonth ?? '').trim().isNotEmpty) {
              //   _expiryMonth = t.expiryMonth;
              // }
              // if ((t.expiryYear ?? '').trim().isNotEmpty) {
              //   _expiryYear = t.expiryYear;
              // }
            });
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_syncToState);
    _lastNameController.removeListener(_syncToState);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passportNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(evisaApplicationProvider);
    final bio = state.passportBioByIndex.length > widget.applicantIndex
        ? state.passportBioByIndex[widget.applicantIndex]
        : null;
    final frontUrl = _resolveImageUrl(_frontImageUrl ?? bio?.frontImageUrl);
    final backUrl = _resolveImageUrl(_backImageUrl ?? bio?.backImageUrl);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildLabel('First Name*'),
        8.ht,
        _buildTextField(
          controller: _firstNameController,
          hint: 'eg. Jhon',
          prefixIcon: ImageUrl.personIcon,
          onChanged: _syncToState,
        ),
        24.ht,
        _buildLabel('Last Name*'),
        8.ht,
        _buildTextField(
          controller: _lastNameController,
          hint: 'eg. Smith',
          prefixIcon: ImageUrl.personIcon,
          onChanged: _syncToState,
        ),
        24.ht,

        AppCustomDropdown<String>(
          title: 'Issue Country',
          hint: 'eg. USA',
          maxHeight: 180,
          value: countryFromName(_issueCountry),
          itemLabel: (v) => v,
          onChanged: (c) {
            setState(() => _issueCountry = c.name);
            _syncToState();
          },
        ),
        24.ht,
        _buildLabel('Passport Number*'),
        8.ht,
        _buildTextField(
          controller: _passportNumberController,
          hint: 'eg. F78FS58SSRF',
          prefixIcon: ImageUrl.documentIcon,
          onChanged: _syncToState,
        ),
        24.ht,
        _buildLabel('Passport Expiry Date'),
        8.ht,
        Row(
          children: [
            Expanded(
              child: AppDropdown<String>(
                value: _expiryMonth,
                title: 'Month',
                hint: 'Month',
                items: months(),
                onChanged: (value) {
                  setState(() => _expiryMonth = value);
                  _syncToState();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppDropdown<String>(
                value: _expiryDay,
                title: 'Day',
                hint: 'Day',
                items: daysByMonthYear(
                  int.tryParse(_expiryYear ?? '2030'),
                  _expiryMonth != null ? getMonthNumber(_expiryMonth!) : null,
                ),
                onChanged: (value) {
                  setState(() => _expiryDay = value);
                  _syncToState();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppDropdown<String>(
                value: _expiryYear,
                title: 'Year',
                hint: 'Year',
                items: years(),
                onChanged: (value) {
                  setState(() => _expiryYear = value);
                  _syncToState();
                },
              ),
            ),
          ],
        ),
        24.ht,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _UploadCard(
                title: 'Passport - Front Photo',
                subTitle: 'Upload a clear scan of your passport photo page',
                imageUrl: frontUrl,
                imageBytes: _frontImageBytes,
                isLoading: _frontLoading,
                onTap: _pickFrontPhoto,
                onRemove: () {
                  setState(() {
                    _frontImageUrl = null;
                    _frontImageBytes = null;
                  });
                  _syncToState();
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _UploadCard(
                title: 'Passport - Back Photo',
                subTitle: 'Upload a recent passport-size photo',
                imageUrl: backUrl,
                imageBytes: _backImageBytes,
                isLoading: _backLoading,
                onTap: _pickBackPhoto,
                onRemove: () {
                  setState(() {
                    _backImageUrl = null;
                    _backImageBytes = null;
                  });
                  _syncToState();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _syncToState() {
    ref
        .read(evisaApplicationProvider.notifier)
        .setPassportBio(
          widget.applicantIndex,
          PassportBioData(
            firstName: _firstNameController.text.isEmpty
                ? null
                : _firstNameController.text,
            lastName: _lastNameController.text.isEmpty
                ? null
                : _lastNameController.text,
            issueCountry: _issueCountry,
            number: _passportNumberController.text.isEmpty
                ? null
                : _passportNumberController.text,
            expiryDay: _expiryDay,
            expiryMonth: _expiryMonth,
            expiryYear: _expiryYear,
            frontImageUrl: _frontImageUrl,
            backImageUrl: _backImageUrl,
          ),
        );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: context.titleSmall?.copyWith(
        fontSize: 14,
        fontFamily: FontFamily.outfitRegular,
        color: AppColors.darkTextColor,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String prefixIcon,
    VoidCallback? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: TextFormField(
        controller: controller,
        onChanged: (_) => onChanged?.call(),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: context.bodyMedium?.copyWith(
            color: AppColors.lightSubText,
            fontFamily: FontFamily.outfitRegular,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: Image.asset(
              prefixIcon,
              height: 20,
              width: 20,
              color: AppColors.lightSubText,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 24,
          ),
        ),
        style: context.bodyMedium?.copyWith(
          fontFamily: FontFamily.outfitRegular,
          color: AppColors.darkTextColor,
        ),
      ),
    );
  }
}

class _UploadCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String? imageUrl;
  final Uint8List? imageBytes;
  final bool isLoading;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _UploadCard({
    required this.title,
    required this.subTitle,
    required this.imageUrl,
    this.imageBytes,
    this.isLoading = false,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage =
        (imageBytes?.isNotEmpty == true) || (imageUrl?.isNotEmpty == true);

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.textFieldBorderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.titleSmall?.copyWith(
                fontSize: 14,
                fontFamily: FontFamily.outfitRegular,
                color: AppColors.darkTextColor,
              ),
            ),
            12.ht,
            Container(
              height: 180,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
              ),
              clipBehavior: Clip.antiAlias,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : !hasImage
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          ImageUrl.uploadIcon,
                          color: AppColors.darkSubText,
                          height: 26,
                        ),
                        8.ht,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            subTitle,
                            textAlign: TextAlign.center,
                            style: context.bodyMedium?.copyWith(
                              fontFamily: FontFamily.outfitRegular,
                              color: AppColors.darkSubText,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        if (imageBytes?.isNotEmpty == true)
                          Image.memory(imageBytes!, fit: BoxFit.cover)
                        else if (imageUrl != null && imageUrl!.isNotEmpty)
                          Positioned.fill(
                            child: AppCacheNetworkImage(
                              url: imageUrl!,
                              boxFit: BoxFit.cover,
                            ),
                          ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: GestureDetector(
                            onTap: onRemove,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.lightBackground,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                ImageUrl.closeRedIcon,
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ),
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
