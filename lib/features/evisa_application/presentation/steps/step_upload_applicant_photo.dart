import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:register_visa_web_app/core/constants/api_end_points.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/features/evisa_application/providers/evisa_application_provider.dart';
import 'package:register_visa_web_app/features/visa_process/presentation/widget/passport_photo_instructions.dart';
import 'package:register_visa_web_app/features/visa_process/presentation/widget/passport_size_upload_card.dart';
import 'package:register_visa_web_app/shared/services/dio_service.dart';
import 'package:register_visa_web_app/shared/services/image_picker_service.dart';
import 'package:register_visa_web_app/shared/services/response_model.dart';

class StepUploadApplicantPhoto extends ConsumerStatefulWidget {
  const StepUploadApplicantPhoto({super.key, this.applicantIndex = 0});

  final int applicantIndex;

  @override
  ConsumerState<StepUploadApplicantPhoto> createState() => _StepUploadApplicantPhotoState();
}

class _StepUploadApplicantPhotoState extends ConsumerState<StepUploadApplicantPhoto> {
  String? _imageUrl;
  List<int>? _imageBytes;
  bool _isLoading = false;
  String? _error;

  void _onPhotoChanged(String? url, List<int>? bytes) {
    setState(() {
      _imageUrl = url;
      _imageBytes = bytes;
      _error = null;
    });
    ref.read(evisaApplicationProvider.notifier).setApplicantPhotoUrl(widget.applicantIndex, url);
  }

  Future<ResponseAPI> _uploadPassportSizePhoto(XFile file, Uint8List bytes) async {
    return ApiManager.multipartAPI(
      methodName: ApiEndpoints.uploadPassportSizePhoto,
      params: {"image": dio.MultipartFile.fromBytes(bytes, filename: file.name)},
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(evisaApplicationProvider);
      if (state.applicantPhotoUrlByIndex.length > widget.applicantIndex) {
        final url = state.applicantPhotoUrlByIndex[widget.applicantIndex];
        if (url != null && mounted) setState(() => _imageUrl = url);
      }
    });
  }

  Future<void> _pickPhoto() async {
    setState(() => _isLoading = true);
    setState(() => _error = null);
    try {
      final picked = await ImagePickerService().pickImageFromGallery2();
      if (picked == null || !mounted) return;
      final bytes = await picked.readAsBytes();
      final fileSizeKB = bytes.length / 1024;
      if (fileSizeKB < 20 || fileSizeKB > 600) {
        setState(() => _error = "Photo size must be greater than 20 KB and less than 600 KB.");
        return;
      }
      final img = await decodeImageFromList(Uint8List.fromList(bytes));
      final width = img.width;
      final height = img.height;
      if ((width <= 350 && height <= 350) || (width >= 1000 && height >= 1000)) {
        setState(() => _error = "Photo dimensions must be between 350x350 and 1000x1000 pixels.");
        return;
      }
      final value = await _uploadPassportSizePhoto(picked, Uint8List.fromList(bytes));
      if (!mounted) return;
      final data = value.data as Map<String, dynamic>?;
      if (data?["statusCode"] == 200) {
        final url = data?["data"]?["url"]?.toString();
        if (url != null && url.isNotEmpty) {
          _onPhotoChanged(url, bytes);
          debugPrint('Uploaded photo URL: $url');
        } else {
          setState(() => _error = data?["message"]?.toString() ?? "Upload failed");
        }
      } else {
        setState(() => _error = data?["message"]?.toString() ?? "Upload failed");
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void didUpdateWidget(StepUploadApplicantPhoto oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.applicantIndex != widget.applicantIndex) {
      final state = ref.read(evisaApplicationProvider);
      final url = state.applicantPhotoUrlByIndex.length > widget.applicantIndex ? state.applicantPhotoUrlByIndex[widget.applicantIndex] : null;
      setState(() {
        _imageUrl = url;
        _imageBytes = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadCard = PassportSizeUploadCard(
      isLoading: _isLoading,
      imageUrl: _imageUrl,
      imageBytes: _imageBytes != null ? Uint8List.fromList(_imageBytes!) : null,
      height: 240,
      width: 340,
      onTap: _pickPhoto,
      onRemove: () => _onPhotoChanged(null, null),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRow = constraints.maxWidth > 560;
        final errorWidget = _error != null
            ? Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12)),
              )
            : const SizedBox.shrink();
        if (useRow) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [uploadCard, errorWidget]),
              const SizedBox(width: 32),
              const Expanded(child: PassportPhotoInstructions()),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [uploadCard, errorWidget, 16.ht, const PassportPhotoInstructions()],
        );
      },
    );
  }
}
