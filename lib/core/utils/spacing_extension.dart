// lib/extensions/size_box_extensions.dart
import 'package:flutter/widgets.dart';

/// Handy SizedBox/spacing extensions for `num` (works for int & double).
/// Examples:
///   8.h        -> SizedBox(height: 8)
///   16.w       -> SizedBox(width: 16)
///   12.sizedBox -> SizedBox(width: 12, height: 12)
///   20.verticalGap -> SizedBox(height: 20)
///   20.horizontalGap -> SizedBox(width: 20)
extension SizeBoxNumExtensions on num {
  /// SizedBox with height = this
  SizedBox get ht => SizedBox(height: toDouble());

  /// SizedBox with width = this
  SizedBox get wt => SizedBox(width: toDouble());

  /// Square SizedBox (width and height the same)
  SizedBox get sizedBox => SizedBox(width: toDouble(), height: toDouble());

  /// Named: vertical gap (same as `.h`)
  SizedBox get verticalGap => SizedBox(height: toDouble());

  /// Named: horizontal gap (same as `.w`)
  SizedBox get horizontalGap => SizedBox(width: toDouble());

  /// Return EdgeInsets symmetric vertical = this
  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: toDouble());

  /// Return EdgeInsets symmetric horizontal = this
  EdgeInsets get horizontalPadding => EdgeInsets.symmetric(horizontal: toDouble());

  /// Return EdgeInsets all = this
  EdgeInsets get allPadding => EdgeInsets.all(toDouble());
}
