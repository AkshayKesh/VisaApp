import 'package:flutter_riverpod/legacy.dart';
import 'package:register_visa_web_app/features/profile/domain/visa_application.dart';
import 'package:register_visa_web_app/features/profile/providers/states/document_list_state.dart';

class DocumnetController extends StateNotifier<Documentstate> {
  DocumnetController() : super(Documentstate()) {
    loadInitialDocuments();
  }
  // Initialize with the dummy items list from MyDocumentsPage
  void loadInitialDocuments() {
    final initialDocuments = [
      VisaApplication(
        travelerName: 'John Doe',
        appliedDate: '01/15/2030',
        country: 'United States',
        status: 'Active',
      ),
      // Jane Smith
      VisaApplication(
        travelerName: 'Jane Smith',
        appliedDate: '06/20/2029',
        country: 'United Kingdom',
        status: 'Active',
      ),
    ];

    state = state.copyWith(
      isLoading: false,
      isSuccess: true,
      error: null,
      data: initialDocuments,
    );
  }

  // Call this in the constructor
}
