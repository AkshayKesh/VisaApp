import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/app_toast.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/core/utils/utils.dart';

import 'package:register_visa_web_app/features/visa_details/providers/details_provider.dart';
import 'package:register_visa_web_app/features/visa_process/domain/traveller_model.dart';
import 'package:register_visa_web_app/features/visa_process/presentation/widget/custome_expansion_panel.dart';
import 'package:register_visa_web_app/features/visa_process/providers/application_provider.dart';
import 'package:register_visa_web_app/shared/services/storage_services.dart';
import 'package:register_visa_web_app/shared/widgets/app_drop_down.dart';
import 'package:register_visa_web_app/shared/widgets/app_text_field.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../core/constants/app_constant.dart';

/// Years from 1900 to current year (no future years). For this file only.
List<String> _yearsUpToCurrent() =>
    List.generate(DateTime.now().year - 1900 + 1, (i) => (1900 + i).toString());

/// Years from current year to 2046 (no past years). For passport expiry.
List<String> _yearsFromCurrent() => List.generate(
  2046 - DateTime.now().year + 1,
  (i) => (DateTime.now().year + i).toString(),
);

final _nameInputFormatters = [
  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
];

final _passportInputFormatters = [
  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
  TextInputFormatter.withFunction(
    (oldValue, newValue) => TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    ),
  ),
];

class TravelerDetails extends ConsumerStatefulWidget {
  const TravelerDetails({super.key});

  @override
  ConsumerState<TravelerDetails> createState() => _TravelerDetailsState();
}

class _TravelerDetailsState extends ConsumerState<TravelerDetails>
    with TickerProviderStateMixin {
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
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      visaApplicationProvider(ref.watch(personCountProvider)),
    );
    final controller = ref.read(
      visaApplicationProvider(ref.watch(personCountProvider)).notifier,
    );

    final travellers = state.travellers;

    screenSize = getSize(context);

    final expandedList = ref.watch(expansionListProvider(travellers.length));

    if (travellers.isEmpty) {
      return const Center(child: Text('No travellers added'));
    }
    ref.listen(visaApplicationProvider(ref.watch(personCountProvider)), (
      previous,
      next,
    ) {
      if (next.error?.isNotEmpty ?? false) {
        AppToast.error(context, '${next.error}');
      }
      if (next.isSuccess) {
        ref.read(activeStepProvider.notifier).setActiveStep(2);
      }
    });

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Details',
                style: context.displaySmall?.copyWith(
                  color: AppColors.darkBackground.withValues(alpha: 0.8),
                  fontFamily: FontFamily.outfitBold,
                ),
              ),
              10.ht,
              Text(
                'Enter details as they appear on your passport',
                style: context.titleMedium?.copyWith(
                  color: AppColors.darkBackground.withValues(alpha: 0.6),
                ),
              ),
              10.ht,
            ],
          ),
          10.ht,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Expanded(
                flex: 2,
                child: ref.watch(currentStepProvider) == 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: travellers.length,
                        itemBuilder: (context, index) {
                          final traveller = travellers[index];

                          return CustomExpansionPanel(
                            isExpanded: expandedList[index],
                            title: "Traveler #${index + 1}",
                            trailingIcon: const Icon(Icons.person, size: 18),

                            onTap: () {
                              ref
                                  .read(
                                    expansionListProvider(
                                      travellers.length,
                                    ).notifier,
                                  )
                                  .toggle(index);
                            },

                            body: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextFormField(
                                  controller: traveller.firstNameController,
                                  hint: "eg. Jhon smith",
                                  title: "First name",
                                  inputFormatters: _nameInputFormatters,
                                ),
                                10.ht,
                                AppTextFormField(
                                  controller: traveller.lastNameController,
                                  hint: "eg. Smith",
                                  title: "Last name",
                                  inputFormatters: _nameInputFormatters,
                                ),
                                10.ht,
                                Text(
                                  "Date of birth",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                10.ht,

                                Row(
                                  children: [
                                    Expanded(
                                      child: AppDropdown(
                                        title: "Month",
                                        hint: "Month",
                                        items: months(),
                                        onChanged: (value) {
                                          controller.changeMonth(value, index);
                                        },
                                        value: traveller.birthMonth,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: AppDropdown(
                                        title: "Day",
                                        hint: "Day",
                                        items: daysByMonthYear(
                                          int.tryParse(
                                            traveller.birthYear.toString(),
                                          ),
                                          getMonthNumber(
                                            traveller.birthMonth.toString(),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          controller.changeDay(value, index);
                                        },
                                        value: traveller.birthDay,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: AppDropdown(
                                        value: traveller.birthYear,
                                        title: "Year",
                                        items: _yearsUpToCurrent(),
                                        onChanged: (value) {
                                          controller.changeYear(value, index);
                                        },
                                        hint: "Year",
                                      ),
                                    ),
                                  ],
                                ),

                                if (index == 0) ...[
                                  const SizedBox(height: 10),
                                  AppTextFormField(
                                    controller: traveller.emailController!,
                                    title: "Email address",
                                    hint: '',
                                    isReadOnly: (HiveService.getEmail() == null)
                                        ? false
                                        : true,
                                  ),
                                ] else ...[
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: CustomIconButton(
                                      height: 30,
                                      color: AppColors.redColor,
                                      text: "Remove",
                                      onPressed: () {
                                        controller.removeTraveler(traveller.id);
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: travellers.length,
                        itemBuilder: (context, index) {
                          final traveller = travellers[index];

                          return CustomExpansionPanel(
                            isExpanded: expandedList[index],
                            title: "Traveler #${index + 1}",
                            trailingIcon: const Icon(Icons.person, size: 18),

                            onTap: () {
                              ref
                                  .read(
                                    expansionListProvider(
                                      travellers.length,
                                    ).notifier,
                                  )
                                  .toggle(index);
                            },

                            body: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Consumer(
                                  builder: (context, ref, child) {
                                    return AppCustomDropdown(
                                      title: "Passport",
                                      hint: "Select",
                                      maxHeight: 180,
                                      value: traveller.country,
                                      itemLabel: (value) => value,
                                      onChanged: (value) {
                                        controller.updateMyPassportCountry(
                                          value,
                                          index,
                                        );
                                      },
                                    );
                                  },
                                ),
                                10.ht,
                                AppTextFormField(
                                  controller:
                                      traveller.passportNumberController,
                                  hint: "eg. GD4F56D4F56D",
                                  title: "Passport Number",
                                  inputFormatters: _passportInputFormatters,
                                ),
                                10.ht,
                                Text(
                                  "Passport expiry date",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                10.ht,
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppDropdown(
                                        value: traveller.passportExpiryMonth,
                                        title: "Month",
                                        hint: "Month",
                                        items: months(),
                                        onChanged: (value) {
                                          controller.updateExpireMonth(
                                            value ?? "1",
                                            index,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: AppDropdown(
                                        value: traveller.passportExpiryDay,
                                        title: "Day",
                                        hint: "Day",
                                        items: daysByMonthYear(
                                          int.tryParse(
                                                traveller.passportExpiryDay ??
                                                    "1",
                                              ) ??
                                              1,
                                          getMonthNumber(
                                            traveller.passportExpiryMonth
                                                .toString(),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          controller.updateExpireDay(
                                            value,
                                            index,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: AppDropdown(
                                        value: traveller.passportExpiryYear,
                                        title: "Year",
                                        items: _yearsFromCurrent(),
                                        onChanged: (value) {
                                          controller.updateExpireYear(
                                            value,
                                            index,
                                          );
                                        },
                                        hint: "Year",
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              if (screenSize == ScreenSize.extraLarge ||
                  screenSize == ScreenSize.large)
                Expanded(
                  child: Column(
                    spacing: 20,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey100, // Background for tile
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.darkBackground.withValues(
                              alpha: 0.4,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "India Tourist eVisa",
                                style: context.titleSmall?.copyWith(
                                  color: AppColors.darkBackground.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "${travellers.length} Travellers",
                              style: context.titleSmall?.copyWith(
                                color: AppColors.blackColor.withValues(
                                  alpha: 0.8,
                                ),
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "Total",
                              style: context.titleSmall?.copyWith(
                                color: AppColors.darkBackground,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              "Calculated at checkout",
                              style: context.titleSmall?.copyWith(
                                color: AppColors.darkBackground,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      CustomIconButton(
                        buttonState: state.isSubmit,
                        width: double.infinity,
                        text: "Save and Continue",
                        onPressed: () {
                          if (ref.read(currentStepProvider.notifier).state ==
                              0) {
                            String? error = controller.checkTravelerBasicInfo();
                            if (error != null) {
                              AppToast.error(context, error);
                              return;
                            }
                            ref.read(currentStepProvider.notifier).state = 1;
                          } else {
                            if (ref.read(currentStepProvider.notifier).state ==
                                1) {
                              String? error = controller.checkPassportDetails();
                              if (error != null) {
                                AppToast.error(context, error);
                                return;
                              }
                              controller.saveTraveler(travellers);
                            }
                          }
                        },
                        height: 40,
                      ),

                      Row(
                        children: [
                          Icon(Icons.arrow_back),
                          TextButton(
                            onPressed: () {
                              if (ref
                                      .read(currentStepProvider.notifier)
                                      .state ==
                                  1) {
                                ref.read(currentStepProvider.notifier).state =
                                    0;
                              } else {
                                context.pop();
                              }
                            },
                            child: Text("Back"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (ref.read(currentStepProvider.notifier).state == 0) ...[
            10.ht,
            CustomIconButton(
              text: 'Add Traveller',
              onPressed: controller.addTraveller,
              icon: const Icon(Icons.add, color: Colors.white, size: 16),
              color: AppColors.primaryBlue,
              textColor: Colors.white,
              height: 35,
              width: 130,
              borderRadius: 8,
              textSize: 14,
              iconSize: 16,
            ),
          ],
          if (screenSize == ScreenSize.normal) ...[
            SizedBox(height: 5.h),
            Column(
              spacing: 20,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey100, // Background for tile
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.darkBackground.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "India Tourist eVisa",
                        style: context.titleSmall?.copyWith(
                          color: AppColors.darkBackground.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ),
                      Text(
                        "${travellers.length} Travellers",
                        style: context.titleSmall?.copyWith(
                          color: AppColors.blackColor.withValues(alpha: 0.8),
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: context.titleSmall?.copyWith(
                        color: AppColors.darkBackground,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Calculated at checkout",
                      style: context.titleSmall?.copyWith(
                        color: AppColors.darkBackground,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                CustomIconButton(
                  buttonState: state.isSubmit,
                  width: double.infinity,
                  text: "Save and Continue",
                  onPressed: () {
                    if (ref.read(currentStepProvider.notifier).state == 0) {
                      String? error = controller.checkTravelerBasicInfo();
                      if (error != null) {
                        AppToast.error(context, error);
                        return;
                      }
                      ref.read(currentStepProvider.notifier).state = 1;
                    } else {
                      if (ref.read(currentStepProvider.notifier).state == 1) {
                        String? error = controller.checkPassportDetails();
                        if (error != null) {
                          AppToast.error(context, error);
                          return;
                        }
                        controller.saveTraveler(travellers);
                      }
                    }
                  },
                  height: 40,
                ),

                Row(
                  children: [
                    Icon(Icons.arrow_back),
                    TextButton(
                      onPressed: () {
                        if (ref.read(currentStepProvider.notifier).state == 1) {
                          ref.read(currentStepProvider.notifier).state = 0;
                        } else {
                          context.pop();
                        }
                      },
                      child: Text("Back"),
                    ),
                  ],
                ),
              ],
            ),
          ],

          // Container(
          //   height: 40,
          //   padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          //   decoration: BoxDecoration(color: AppColors.lightGrey100, borderRadius: BorderRadius.circular(8)),
          //   child: TabBar(
          //     padding: EdgeInsets.zero,
          //     tabAlignment: TabAlignment.start,
          //     controller: _tabController,
          //     isScrollable: true,
          //     onTap: (value) {
          //       controller.changeTraveller(value);
          //     },
          //     indicatorSize: TabBarIndicatorSize.tab,
          //     indicator: BoxDecoration(
          //       backgroundBlendMode: BlendMode.clear,
          //       color: selectedColor,
          //       borderRadius: BorderRadius.circular(8),
          //       boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
          //     ),
          //     tabs: travellers
          //         .map(
          //           (traveller) => Tab(
          //             child: _buildTab(traveller, travellers.length, () {
          //               if (travellers.length > 1) {
          //                 controller.changeTraveller(state.currentTravellerIndex - 1);
          //                 controller.removeTraveler(traveller.id);
          //               }
          //             }, travellers),
          //           ),
          //         )
          //         .toList(),
          //   ),
          // ),
          // 20.ht,
          // TravelDetailsForm(context: context, traveller: travellers[currentIndex], isSmallScreen: screenSize == ScreenSize.small),
          //
          // 20.ht,
          //
          // Center(
          //   child: SizedBox(
          //     width: 300,
          //     child: CustomIconButton(
          //       buttonState: state.isSubmit,
          //       text: 'Save and Continue',
          //       onPressed: () async {
          //         String? error = controller.checkTravelerDetails();
          //         if (error != null) {
          //           AppToast.error(context, error);
          //           return;
          //         }
          //         await controller.saveTraveler(travellers);
          //       },
          //       color: AppColors.primaryBlue,
          //       textColor: Colors.white,
          //       height: 40,
          //       borderRadius: 8,
          //     ),
          //   ),
          // ),
          // 40.ht, // Spacing at the bottom
        ],
      ),
    );
  }

  Widget _buildTab(
    Traveller traveller,
    int travelerSize,
    Function onRemove,
    List<Traveller> travellers,
  ) {
    return SizedBox(
      height: 50, // IMPORTANT: ListView needs bounded height
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          const Icon(Icons.person, size: 18),
          const SizedBox(width: 8),
          Text(
            'Traveller ${travellers.indexOf(traveller) + 1}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          if (travelerSize > 1) ...[
            const SizedBox(width: 8),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onRemove(),
              child: CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.redColor.withValues(alpha: 0.3),
                child: Icon(Icons.close, color: AppColors.redColor, size: 14),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class TravellerTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;
  final Color trackColor;
  final Color selectedColor;
  final Color unselectedTextColor;
  final Color selectedTextColor;

  const TravellerTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    required this.trackColor,
    required this.selectedColor,
    required this.unselectedTextColor,
    required this.selectedTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent, // remove bottom border
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: trackColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TabBar(
          controller: controller,
          isScrollable: true,
          padding: EdgeInsets.zero,
          indicatorSize: TabBarIndicatorSize.tab,

          // remove default underline
          indicatorColor: Colors.transparent,
          indicatorWeight: 0,
          indicatorPadding: EdgeInsets.zero,

          // custom pill
          indicator: BoxDecoration(
            color: selectedColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),

          // text styles
          labelColor: selectedTextColor,
          unselectedLabelColor: unselectedTextColor,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),

          tabs: List.generate(
            tabs.length,
            (index) => Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: controller.index == index
                        ? selectedTextColor
                        : unselectedTextColor,
                  ),
                  const SizedBox(width: 6),
                  Text(tabs[index]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TravelerFormPage extends StatefulWidget {
  const TravelerFormPage({super.key});

  @override
  State<TravelerFormPage> createState() => _TravelerFormPageState();
}

class _TravelerFormPageState extends State<TravelerFormPage> {
  List<bool> expandedList = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      children: [
        ExpansionPanelList(
          elevation: 0,
          expandedHeaderPadding: EdgeInsets.zero,
          dividerColor: Colors.grey.shade300,
          expansionCallback: (index, isExpanded) {
            setState(() {
              expandedList[index] = !isExpanded;
            });
          },
          children: List.generate(expandedList.length, (index) {
            return ExpansionPanel(
              isExpanded: expandedList[index],
              canTapOnHeader: true,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Text(
                    "Traveler #${index + 1}",
                    style: context.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: _travelerForm(),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _travelerForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextFormField(
          controller: TextEditingController(),
          hint: "",
          title: "First and middle name",
        ),

        AppTextFormField(
          controller: TextEditingController(),
          hint: "",
          title: "Last name",
        ),

        _label("Date of birth"),
        Row(
          children: [
            Expanded(child: _dropdown("Day")),
            const SizedBox(width: 12),
            Expanded(child: _dropdown("Month")),
            const SizedBox(width: 12),
            Expanded(child: _dropdown("Year")),
          ],
        ),

        AppTextFormField(
          controller: TextEditingController(),
          hint: "",
          title: "Email address",
        ),

        // const SizedBox(height: 12),
        //
        // Row(
        //   children: [
        //     Checkbox(value: false, onChanged: (v) {}),
        //     const Expanded(
        //       child: Text(
        //         "I want to receive iVisa updates, product launches and personalized offers. "
        //         "Terms and Privacy Policy apply.",
        //         style: TextStyle(fontSize: 12),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _textField(String hint) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _dropdown(String hint) {
    return DropdownButtonFormField<String>(
      items: [],
      onChanged: (v) {},
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
