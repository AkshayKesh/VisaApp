enum VisaType {
  businessVisa('business visa', 'Business Visa'),
  eVisa('e-visa', 'E-Visa'),
  transitVisa('transit visa', 'Transit Visa'),
  touristVisa('tourist visa', 'Tourist Visa'),
  workVisa('work visa', 'Work Visa'),
  studentVisa('student visa', 'Student Visa');

  final String key;
  final String label;

  const VisaType(this.key, this.label);

  /// Get LABEL from KEY
  static String? getLabelFromKey(String? key) {
    if (key == null) return null;
    return VisaType.values
        .firstWhere(
          (e) => e.key == key,
          orElse: () => throw Exception('Invalid visa key'),
        )
        .label;
  }

  /// Get KEY from LABEL
  static String? getKeyFromLabel(String? label) {
    if (label == null) return null;
    try {
      return VisaType.values
          .firstWhere((e) => e.label.toLowerCase() == label.toLowerCase())
          .key;
    } catch (_) {
      return null;
    }
  }
}
