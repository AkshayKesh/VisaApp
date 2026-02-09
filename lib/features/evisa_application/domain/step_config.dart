class StepSection {
  static const String uploadIntroStepTitle = 'Instructions';
  static const List<String> uploadStepTitles = ["Applicant's Photo", 'Passport Bio Page', 'Passport details'];

  final int sectionIndex;
  final String title;
  final List<String> subSteps;
  final List<String>? applicantNames;

  const StepSection({
    required this.sectionIndex,
    required this.title,
    required this.subSteps,
    this.applicantNames,
  });
}
