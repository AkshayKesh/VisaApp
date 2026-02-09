extension StringCamelCaseExtension on String {
  /// Converts a string to camel case (Title Case).
  /// Example:
  /// 'mustaq ahmad' -> 'Mustaq Ahmad'
  /// 'mustaq' -> 'Mustaq'
  String toCamelCase() {
    if (trim().isEmpty) return '';

    return trim()
        .split(RegExp(r'\s+'))
        .map(
          (word) => word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1).toLowerCase()
              : '',
        )
        .join(' ');
  }
}
