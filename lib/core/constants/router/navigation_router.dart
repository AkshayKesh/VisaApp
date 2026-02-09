import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/router/router_names.dart';
import 'package:register_visa_web_app/error_widget.dart';
import 'package:register_visa_web_app/features/auth/presentation/login_page.dart';
import 'package:register_visa_web_app/features/auth/presentation/create_password_page.dart';
import 'package:register_visa_web_app/features/evisa_application/presentation/evisa_application_page.dart';
import 'package:register_visa_web_app/features/home/presentation/home_page.dart';
import 'package:register_visa_web_app/features/payment/presentation/payment_page.dart';
import 'package:register_visa_web_app/features/profile/presentation/card/card_page.dart';
import 'package:register_visa_web_app/features/profile/presentation/change_password/change_password.dart';
import 'package:register_visa_web_app/features/profile/presentation/document/document_details.dart';
import 'package:register_visa_web_app/features/profile/presentation/document/domain/passport_listing_model.dart';
import 'package:register_visa_web_app/features/profile/presentation/document/my_documents_page.dart';
import 'package:register_visa_web_app/features/profile/presentation/help/help_page.dart';
import 'package:register_visa_web_app/features/profile/presentation/profile/profile_page.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/draft_payment_page.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/traveler_details_page.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/visa_page.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa_management_page.dart';
import 'package:register_visa_web_app/features/submission/presentation/submission_page.dart';
import 'package:register_visa_web_app/features/visa_details/presentation/visa_details_page.dart';
import 'package:register_visa_web_app/features/visa_process/presentation/visa_application_page.dart';

class NavigationRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouterNames.home,
    //errorBuilder: (context, state) => PageNotFoundPage(),
    routes: [
      GoRoute(
        path: RouterNames.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            path: 'create-password',
            name: 'createPassword',
            builder: (context, state) {
              final email = state.extra as String;
              return CreatePasswordPage(email: email);
            },
          ),
        ],
      ),
      GoRoute(
        path: RouterNames.evisaApplication,
        name: 'evisaApplication',
        builder: (context, state) {
          final applicationId = state.extra is String
              ? state.extra as String?
              : state.queryParameters['applicationId'];
          return EvisaApplicationPage(applicationId: applicationId);
        },
      ),
      GoRoute(
        path: RouterNames.home,
        name: 'home',
        builder: (context, state) => MyHomePage(),
        routes: [
          GoRoute(
            path: RouterNames.viewDetails,
            name: RouterNames.viewDetails,
            builder: (context, state) {
              return VisaDetailsPage();
            },
            routes: [
              GoRoute(
                path: RouterNames.applicationPage,
                name: RouterNames.applicationPage,
                builder: (context, state) {
                  return VisaApplicationPage();
                },
                routes: [
                  GoRoute(
                    path: RouterNames.payment,
                    name: RouterNames.payment,
                    builder: (context, state) => const PaymentPage(),
                    routes: [],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouterNames.paymentSubmission,
        name: RouterNames.paymentSubmission,
        builder: (context, state) => const SubmissionPage(),
      ),

      GoRoute(
        path: RouterNames.profile,
        builder: (context, state) => const UserProfilePage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return VisaManagementPage(child: child);
        },
        routes: [
          GoRoute(
            path: RouterNames.visaPage,
            builder: (context, state) => VisaPage(),
            routes: [
              GoRoute(
                path: "${RouterNames.travelerDetails}/:applicationId",
                builder: (context, state) {
                  String? appId = state.pathParameters["applicationId"];
                  return TravelerDetailsScreen(appId: appId ?? '');
                },
              ),
              GoRoute(
                // ✅ FIXED HERE
                path:
                    "${RouterNames.draftPaymentPage}/:applicationId/:packageId",
                builder: (context, state) {
                  final appId = state.pathParameters["applicationId"]!;
                  final packageId = state.pathParameters["packageId"]!;
                  return DraftPaymentPage(appId: appId, packageId: packageId);
                },
              ),
            ],
          ),
          GoRoute(
            path: RouterNames.document,
            builder: (context, state) => MyDocumentsPage(),
            routes: [
              GoRoute(
                path: RouterNames.passportDetails,
                builder: (context, state) {
                  final extra = state.extra;
                  PassportListingModel? passport;
                  if (extra is PassportListingModel) {
                    passport = extra;
                  } else if (extra != null && extra is Map<String, dynamic>) {
                    // Support for cases where extra is a Map (e.g., via pushNamed)
                    passport = PassportListingModel.fromJson(extra);
                  } else {
                    passport = null;
                  }
                  return DocumentDetailPage(model: passport);
                },
              ),
            ],
          ),
          GoRoute(
            path: RouterNames.card,
            builder: (context, state) => CardPage(),
          ),
          GoRoute(
            path: RouterNames.help,
            builder: (context, state) => HelpPage(),
          ),
          GoRoute(
            path: RouterNames.forgotPassword,
            builder: (context, state) => ForgotPasswordPage(),
          ),
        ],
      ),
    ],
  );
}
