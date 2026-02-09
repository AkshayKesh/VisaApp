import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';

class VisaDestinationCard extends StatelessWidget {
  final String? imageUrl;
  final String? badgeText;
  final IconData? badgeIcon;

  final String? title;
  final String? subtitle;
  final IconData? subtitleIcon;

  final double height;
  final double borderRadius;
  final VoidCallback? onTap; // Add onTap callback

  const VisaDestinationCard({
    super.key,
    this.imageUrl,
    this.badgeText,
    this.badgeIcon,
    this.title,
    this.subtitle,
    this.subtitleIcon,
    this.height = 230,
    this.borderRadius = 22,
    this.onTap, // Initialize onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Use the provided onTap callback
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            children: [
              // Background image using CachedNetworkImage
              if (imageUrl != null && imageUrl!.isNotEmpty)
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade300,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 48,
                      ),
                    ),
                  ),
                )
              else
                Positioned.fill(
                  child: Container(
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 48,
                    ),
                  ),
                ),

              // Gradient overlay at bottom
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.05),
                        Colors.black.withValues(alpha: 0.75),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // Badge (top-left)
              // if (badgeText != null)
              //   Positioned(
              //     top: 16,
              //     left: 16,
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 14,
              //         vertical: 6,
              //       ),
              //       decoration: BoxDecoration(
              //         color: const Color(0xff0D1B4C),
              //         borderRadius: BorderRadius.circular(30),
              //       ),
              //       child: Row(
              //         children: [
              //           if (badgeIcon != null)
              //             Icon(
              //               badgeIcon,
              //               color: Colors.white,
              //               size: 24,
              //             ), // Adjust icon size with text
              //           if (badgeIcon != null) const SizedBox(width: 6),
              //           Text(
              //             badgeText!,
              //             style: context.bodyMedium?.copyWith(
              //               color: Colors.white,
              //               fontSize: 14,
              //               fontFamily: FontFamily.outfitSemiBold,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),

              // Bottom Text Section
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: context.headlineLarge?.copyWith(
                          color: AppColors.lightBackground,
                          fontSize: 12.0,
                          fontFamily: FontFamily.outfitSemiBold,
                        ),
                      ),

                    4.ht,

                    if (subtitle != null)
                      Row(
                        children: [
                          Icon(
                            subtitleIcon ?? Icons.access_time,
                            color: Colors.white70,
                            size: 12, // Adjust icon size with text
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              subtitle!,
                              style: context.bodySmall?.copyWith(
                                color: AppColors.lightBackground,
                                fontSize: 12,
                                fontFamily: FontFamily.outfitLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
