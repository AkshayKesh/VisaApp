import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/router/router_names.dart';
import 'package:register_visa_web_app/core/utils/string_logger_extension.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/domain/application_listing_model.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/domain/visa_list_param.dart';
import 'package:register_visa_web_app/features/profile/presentation/widget/visa_row.dart';
import 'package:register_visa_web_app/shared/services/visa_hive_service.dart';
import 'package:register_visa_web_app/shared/widgets/custome_pagination.dart';

class PendingVisaPage extends StatelessWidget {
  const PendingVisaPage({
    super.key,
    required this.applications,
    required this.param,
    required this.onNext,
    required this.onPrevious,
    required this.totalItems,
    required this.currentPage,
  });
  final List<ApplicationsModle> applications;
  final VisaListParam param;
  final int totalItems;
  final int currentPage;
  final Function(VisaListParam param) onNext;
  final Function(VisaListParam param) onPrevious;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          ListView.builder(
            itemCount: applications.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              ApplicationsModle details = applications[index];
              "ERROR #${details.toJson()}".logE();
              return VisaRow(
                applicationId: "${applications[index].applicationId}",
                onTap: () {
                  final appId = applications[index].id;
                  VisaHiveService.instance.updateId(appId!);
                  context.go("/visa/${RouterNames.travelerDetails}/$appId");
                },
                appliedData: details.submittedDate.toString(),
                country: "${details.packageDetails?.country}",
                fullName: details.travellerDetails.firstOrNull?.fullName ?? "",
                status: "${details.status}",
                appId: "${details.id}",
              );
            },
          ),
          if (applications.isNotEmpty)
            CustomPagination(
              currentPage: param.page ?? 0,
              pageSize: param.page ?? 0,
              totalItems: totalItems,
              onPrevious: () =>
                  onPrevious(param.copyWith(page: param.page! - 1)),
              onNext: () => onNext(param.copyWith(page: param.page! + 1)),
            ),
        ],
      ),
    );
  }
}
