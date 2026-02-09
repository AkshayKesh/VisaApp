import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/utils/app_toast.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/features/visa_details/providers/details_provider.dart';
import 'package:register_visa_web_app/features/visa_process/presentation/check_out_page.dart';
import 'package:register_visa_web_app/features/visa_process/presentation/traveler_details.dart';
import 'package:register_visa_web_app/features/visa_process/providers/application_provider.dart';
import 'package:register_visa_web_app/shared/services/visa_hive_service.dart';
import 'package:register_visa_web_app/shared/widgets/app_bar_widget.dart';

class VisaApplicationPage extends ConsumerStatefulWidget {
  const VisaApplicationPage({super.key});

  @override
  ConsumerState<VisaApplicationPage> createState() =>
      _VisaApplicationPageState();
}

class _VisaApplicationPageState extends ConsumerState<VisaApplicationPage> {
  final Color containerBg = const Color(
    0xFFF2F5F8,
  ); // outer pill background (light grey)
  final Color selectedColor = Colors.white; // selected tab bg
  final Color indicatorShadowColor = Colors.black12;
  final Color primaryBlue = const Color(
    0xFF3B5EDE,
  ); // label color for selected (example)
  final Color unselectedText = const Color(0xFF8C98A8); // mute

  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    data = VisaHiveService.instance.getVisaMdoel();
  }

  int activeStep = 1;

  @override
  Widget build(BuildContext context) {
    final activeState = ref.watch(activeStepProvider);
    final controller = ref.read(
      visaApplicationProvider(ref.watch(personCountProvider)).notifier,
    );
    controller.setData = data;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(),
            20.ht,
            EasyStepper(
              activeStep: ref.watch(activeStepProvider),
              stepShape: StepShape.rRectangle,
              stepBorderRadius: 15,
              borderThickness: 2,
              stepRadius: 28,
              activeStepBackgroundColor: AppColors.primaryBlue,
              lineStyle: const LineStyle(
                lineLength: 300,
                lineThickness: 2,
                lineType: LineType.normal,
                lineSpace: 0,
              ),

              finishedStepTextColor: Colors.deepOrange,
              finishedStepBackgroundColor: AppColors.primaryBlue,
              activeStepIconColor: Colors.deepOrange,
              showLoadingAnimation: false,
              steps: [
                EasyStep(
                  customStep: Opacity(
                    opacity: activeState == 0 ? 1 : 0.3,
                    child: Image.asset(
                      ImageUrl.flightIcon,
                      color: AppColors.lightBackground,
                      height: 24,
                      width: 24,
                    ),
                  ),
                  customTitle: const Text(
                    'Trip Details',
                    textAlign: TextAlign.center,
                  ),
                ),
                EasyStep(
                  customStep: Opacity(
                    opacity: activeState == 1 ? 1 : 0.3,
                    child: Image.asset(
                      ImageUrl.peopleIcon,
                      color: AppColors.lightBackground,
                      height: 24,
                      width: 24,
                    ),
                  ),
                  customTitle: const Text(
                    'Traveler Details',
                    textAlign: TextAlign.center,
                  ),
                ),
                EasyStep(
                  customStep: Opacity(
                    opacity: activeState == 2 ? 1 : 0.3,
                    child: Image.asset(
                      ImageUrl.cardIcon,
                      color: AppColors.lightBackground,
                      height: 24,
                      width: 24,
                    ),
                  ),
                  customTitle: const Text(
                    'Checkout',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              onStepReached: (index) {
                if (index == 0) {
                  context.pop();
                  return;
                }
                if (index == 1) {
                  String? error = controller.checkTravelerDetails();
                  if (error != null) {
                    AppToast.error(context, error);
                    return;
                  }
                  ref.read(activeStepProvider.notifier).setActiveStep(index);
                }
              },
            ),

            if (activeState == 1) TravelerDetails() else CheckOutPage(),
            20.ht,
          ],
        ),
      ),
    );
  }
}
