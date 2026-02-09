import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/app_text_style.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/approve_visa_page.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/domain/visa_list_param.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/draft_visa_page.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/pending_visa_page.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/provider/application_lisitng_provider.dart';

class VisaPage extends ConsumerStatefulWidget {
  const VisaPage({super.key});

  @override
  ConsumerState<VisaPage> createState() => _VisaPageState();
}

class _VisaPageState extends ConsumerState<VisaPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int currentId = 0;

  final Color containerBg = const Color(
    0xFFF2F5F8,
  ); // outer pill background (light grey)
  final Color selectedColor = Colors.white; // selected tab bg
  final Color indicatorShadowColor = Colors.black12;
  final Color primaryBlue = const Color(
    0xFF3B5EDE,
  ); // label color for selected (example)
  final Color unselectedText = const Color(0xFF8C98A8); // muted text f

  final List<Map<String, String>> _travellers = [
    {"id": "0", "name": "Approved Visa"},
    {"id": "1", "name": "Pending Visa"},
    {"id": "3", "name": "Draft Visa"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _travellers.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // helper to build each tab child (icon + text)
  Widget _buildTab(String name, String index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // You can swap this with Image.asset(ImageUrl.peopleIcon, height: 18)
        index == "0"
            ? Image.asset(ImageUrl.checkMarkIcon, height: 18)
            : Image.asset(ImageUrl.clockIcon, height: 18),
        const SizedBox(width: 8),
        Text(
          name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(applicationStatusFilterProvider);
    final applicationListingState = ref.watch(
      applicationListingProvider(status),
    );

    return DefaultTabController(
      length: _travellers.length,
      initialIndex: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Visa Management',
                style: AppTextStyle.outFitBoldStyle.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 6),
              Text(
                'Track and manage all your visa applications',
                style: AppTextStyle.outFitRegularStyle.copyWith(
                  color: AppColors.lightSubText,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 40,
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TabBar(
                  padding: EdgeInsets.zero,
                  tabAlignment: TabAlignment.start,
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  isScrollable: true,
                  onTap: (index) async {
                    if (index == 0) {
                      ref.read(applicationStatusFilterProvider.notifier).state =
                          VisaListParam(status: "closed", page: 1);
                    } else if (index == 1) {
                      ref.read(applicationStatusFilterProvider.notifier).state =
                          VisaListParam(status: "pending", page: 1);
                    } else {
                      ref.read(applicationStatusFilterProvider.notifier).state =
                          VisaListParam(status: "draft", page: 1);
                    }
                  },
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    backgroundBlendMode: BlendMode.clear,
                    color: selectedColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  tabs: _travellers
                      .map(
                        (data) => Tab(
                          child: _buildTab(
                            data["name"].toString(),
                            data["id"].toString(),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              if (applicationListingState.isLoading)
                Center(
                  child: SpinKitFadingCircle(
                    color: AppColors.primaryBlue,
                    size: 40,
                  ),
                ),
              if (applicationListingState.isSuccess)
                SizedBox(
                  height: 700,
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      ApproveVisaPage(
                        currentPage:
                            applicationListingState.pagination?.currentPage ??
                            0,
                        totalItems:
                            applicationListingState.pagination?.totalRecords ??
                            0,
                        param: ref
                            .watch(applicationStatusFilterProvider.notifier)
                            .state,
                        applications: applicationListingState.applications
                            .toList(),
                        onNext: (param) {
                          ref
                                  .read(
                                    applicationStatusFilterProvider.notifier,
                                  )
                                  .state =
                              param;
                          ref
                              .watch(
                                applicationListingProvider(status).notifier,
                              )
                              .loadMore(param);
                        },
                        onPrevious: (param) {
                          ref
                                  .read(
                                    applicationStatusFilterProvider.notifier,
                                  )
                                  .state =
                              param;
                          ref
                              .watch(
                                applicationListingProvider(status).notifier,
                              )
                              .loadMore(param);
                        },
                      ),
                      PendingVisaPage(
                        currentPage:
                            applicationListingState.pagination?.currentPage ??
                            0,
                        totalItems:
                            applicationListingState.pagination?.totalRecords ??
                            0,
                        param: ref
                            .watch(applicationStatusFilterProvider.notifier)
                            .state,
                        applications: applicationListingState.applications
                            .toList(),
                        onNext: (param) {
                          ref
                                  .read(
                                    applicationStatusFilterProvider.notifier,
                                  )
                                  .state =
                              param;
                          ref.watch(applicationListingProvider(param).notifier);
                        },
                        onPrevious: (param) {
                          ref
                                  .read(
                                    applicationStatusFilterProvider.notifier,
                                  )
                                  .state =
                              param;
                          ref.watch(applicationListingProvider(param).notifier);
                        },
                      ),
                      DraftVisaPage(
                        currentPage:
                            applicationListingState.pagination?.currentPage ??
                            0,
                        totalItems:
                            applicationListingState.pagination?.totalRecords ??
                            0,
                        param: ref
                            .watch(applicationStatusFilterProvider.notifier)
                            .state,
                        applications: applicationListingState.applications
                            .toList(),
                        onNext: (param) {
                          ref
                                  .read(
                                    applicationStatusFilterProvider.notifier,
                                  )
                                  .state =
                              param;

                          ref.read(applicationListingProvider(param).notifier);
                        },
                        onPrevious: (param) {
                          ref
                                  .read(
                                    applicationStatusFilterProvider.notifier,
                                  )
                                  .state =
                              param;
                          ref.watch(applicationListingProvider(param).notifier);
                        },
                      ),
                    ],
                  ),
                ),
              24.ht,
            ],
          ),
        ),
      ),
    );
  }
}
