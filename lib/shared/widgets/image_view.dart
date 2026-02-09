import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import 'package:register_visa_web_app/core/constants/app_color.dart';

class AppCacheNetworkImage extends StatelessWidget {
  final String url;

  final double? height, width;
  final BoxFit? boxFit;

  const AppCacheNetworkImage({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.boxFit,
  });

  @override
  Widget build(BuildContext context) {
    return url == ""
        ? const SizedBox()
        : Stack(
            alignment: Alignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: url,
                height: height,
                width: width,
                fit: boxFit,
                placeholder: (context, url) => const CupertinoActivityIndicator(
                  radius: 20.0,
                  animating: true,
                  color: AppColors.primaryBlue,
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Text(
                    "Image Error",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ),
              ),
            ],
          );
  }
}
