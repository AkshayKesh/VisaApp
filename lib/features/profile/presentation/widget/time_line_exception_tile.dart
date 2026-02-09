// import 'package:flutter/material.dart';
// import 'package:register_visa_web_app/core/constants/font_family.dart';
// import 'package:register_visa_web_app/core/utils/utils.dart';
// import 'package:register_visa_web_app/features/profile/presentation/visa/domain/traveler_app_status_model.dart';
// import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';

// class TimelineExpansionTile extends StatefulWidget {
//   final TravelerAppStatusModel item;
//   final bool isLast;

//   const TimelineExpansionTile({
//     super.key,
//     required this.item,
//     this.isLast = false,
//   });

//   @override
//   State<TimelineExpansionTile> createState() => _TimelineExpansionTileState();
// }

// class _TimelineExpansionTileState extends State<TimelineExpansionTile>
//     with SingleTickerProviderStateMixin {
//   bool _isExpanded = false;
//   late final AnimationController _controller;
//   late final Animation<double> _expandAnim;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 200),
//     );
//     _expandAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _toggle() {
//     setState(() {
//       _isExpanded = !_isExpanded;
//       if (_isExpanded) {
//         _controller.forward();
//       } else {
//         _controller.reverse();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final item = widget.item;

//     return IntrinsicHeight(
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Left timeline marker + line
//           Padding(
//             padding: const EdgeInsets.only(right: 12, top: 6),
//             child: Column(
//               children: [
//                 // Circle marker
//                 Container(
//                   width: 14,
//                   height: 14,
//                   decoration: BoxDecoration(
//                     color: item.statusDetails?.statusName == "Visa Arrived"
//                         ? theme.colorScheme.primary
//                         : theme.disabledColor,
//                     shape: BoxShape.circle,
//                     border: Border.all(color: theme.dividerColor),
//                   ),
//                 ),
//                 // Vertical line connecting markers (skip for last)
//                 if (!widget.isLast)
//                   Expanded(
//                     child: Container(
//                       width: 2,
//                       margin: const EdgeInsets.only(top: 6),
//                       color: item.statusDetails?.statusName == "Visa Arrived"
//                           ? theme.colorScheme.primary
//                           : theme.disabledColor,
//                     ),
//                   )
//                 else
//                   const SizedBox(height: 6),
//               ],
//             ),
//           ),

//           // Right content (expansion tile)
//           Expanded(
//             child: Card(
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(8),
//                 onTap: _toggle,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 8,
//                     horizontal: 8,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Title row (title + time + expand arrow)
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Flexible Title
//                           Expanded(
//                             child: Text(
//                               item.title ?? "",
//                               style: theme.textTheme.bodyMedium?.copyWith(
//                                 fontFamily: FontFamily.outfitMedium,
//                                 fontSize: 16.0,
//                               ),
//                             ),
//                           ),

//                           // Expand/collapse icon
//                           RotationTransition(
//                             turns: Tween(
//                               begin: 0.0,
//                               end: 0.5,
//                             ).animate(_expandAnim),
//                             child: Icon(
//                               _isExpanded
//                                   ? Icons.expand_less
//                                   : Icons.expand_more,
//                               size: 20,
//                               color: theme.hintColor,
//                             ),
//                           ),
//                         ],
//                       ),

//                       // Animated expanded content
//                       SizeTransition(
//                         sizeFactor: _expandAnim,
//                         axisAlignment: -1.0,
//                         child: Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // if (item.dateTime.isNotEmpty)
//                               Text(
//                                 Utils.dateFormat(item.createdAt.toString()),
//                                 style: theme.textTheme.bodySmall?.copyWith(
//                                   color: theme.hintColor,
//                                 ),
//                               ),
//                               // Description
//                               Text(
//                                 item.description ?? "",
//                                 style: theme.textTheme.bodyMedium?.copyWith(
//                                   color: theme.hintColor,
//                                   fontFamily: FontFamily.outfitRegular,
//                                   fontSize: 12.0,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               if (item.documentUrl?.isNotEmpty ?? false)
//                                 Align(
//                                   alignment: Alignment.bottomRight,
//                                   child: CustomIconButton(
//                                     height: 30,
//                                     borderRadius: 6,
//                                     text: "View Document",
//                                     onPressed: () {
//                                       _downloadFile(item.documentUrl);
//                                     },
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _downloadFile(String? documentUrl) {
//     if (documentUrl != null) {
//       Utils.downloadFileWebUsingDio(documentUrl, "document.pdf");
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/utils.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/domain/traveler_app_status_model.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/provider/timeline_expansion_provider.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';

class TimelineExpansionTile extends ConsumerStatefulWidget {
  final TravelerAppStatusModel item;
  final bool isLast;
  final int index;

  const TimelineExpansionTile({
    super.key,
    required this.item,
    required this.index,
    this.isLast = false,
  });

  @override
  ConsumerState<TimelineExpansionTile> createState() =>
      _TimelineExpansionTileState();
}

class _TimelineExpansionTileState extends ConsumerState<TimelineExpansionTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle(bool isExpanded) {
    if (isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = widget.item;

    final expansionKey = item.createdAt.toString();

    final isExpanded = ref.watch(timelineExpansionProvider(expansionKey));

    ref.listen<bool>(
      timelineExpansionProvider(expansionKey),
      (previous, next) => _toggle(next),
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Timeline indicator
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 6),
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.greenColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.dividerColor),
                  ),
                ),
                if (!widget.isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.only(top: 6),
                      color: AppColors.greenColor,
                    ),
                  ),
              ],
            ),
          ),

          /// Right content
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                ref
                    .read(timelineExpansionProvider(expansionKey).notifier)
                    .toggle();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title ?? "",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontFamily: FontFamily.outfitMedium,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        RotationTransition(
                          turns: Tween(
                            begin: 0.0,
                            end: 0.5,
                          ).animate(_expandAnim),
                          child: Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            size: 20,
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),

                    /// Expanded content
                    SizeTransition(
                      sizeFactor: _expandAnim,
                      axisAlignment: -1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utils.formatDayMonthTime(
                                item.createdAt.toString(),
                              ),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                            Text(
                              item.description ?? "",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontFamily: FontFamily.outfitRegular,
                                fontSize: 12,
                                color: theme.hintColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (item.documentUrl?.isNotEmpty ?? false)
                              Align(
                                alignment: Alignment.bottomRight,
                                child: CustomIconButton(
                                  height: 30,
                                  borderRadius: 6,
                                  text: "View Document",
                                  onPressed: () {
                                    Utils.downloadFileWebUsingDio(
                                      item.documentUrl!,
                                      "document.pdf",
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
