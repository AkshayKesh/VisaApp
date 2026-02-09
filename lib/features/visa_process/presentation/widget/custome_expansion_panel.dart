import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';

class CustomExpansionPanel extends StatefulWidget {
  final bool isExpanded;
  final String title;
  final Widget body;
  final VoidCallback onTap;
  final Widget? trailingIcon;

  const CustomExpansionPanel({
    super.key,
    required this.isExpanded,
    required this.title,
    required this.body,
    required this.onTap,
    this.trailingIcon,
  });

  @override
  State<CustomExpansionPanel> createState() => _CustomExpansionPanelState();
}

class _CustomExpansionPanelState extends State<CustomExpansionPanel>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// HEADER
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.headerBackground.withValues(alpha: 0.2),
              borderRadius: BorderRadius.vertical(
                top: const Radius.circular(8),
                bottom: widget.isExpanded
                    ? Radius.zero
                    : const Radius.circular(8),
              ),
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: widget.isExpanded ? 0.5 : 0,
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
        ),

        /// BODY WITH ANIMATION
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: ConstrainedBox(
              constraints: widget.isExpanded
                  ? const BoxConstraints()
                  : const BoxConstraints(maxHeight: 0),
              child: FadeTransition(
                opacity: AlwaysStoppedAnimation(widget.isExpanded ? 1 : 0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: widget.body,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
