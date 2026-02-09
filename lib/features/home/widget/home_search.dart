import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/router/router_names.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/home/domain/package_response.dart';
import 'package:register_visa_web_app/features/home/providers/home_provider.dart';
import 'package:register_visa_web_app/shared/widgets/app_text_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HeroDestinationSearch extends StatefulWidget {
  const HeroDestinationSearch({super.key});

  @override
  State<HeroDestinationSearch> createState() => _HeroDestinationSearchState();
}

class _HeroDestinationSearchState extends State<HeroDestinationSearch> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final LayerLink layerLink = LayerLink();
  Timer? _debounceTimer;
  final GlobalKey _searchKey = GlobalKey();
  double _searchWidth = 0;

  OverlayEntry? overlayEntry;

  void _updateSearchWidth() {
    final renderBox = _searchKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      _searchWidth = renderBox.size.width;
    }
  }

  void showOverlay() {
    if (overlayEntry != null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSearchWidth();
    });

    overlayEntry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: GestureDetector(
          onTap: hideOverlay,
          behavior: HitTestBehavior.translucent,
          child: Stack(
            ///fit: StackFit.expand,
            children: [
              CompositedTransformFollower(
                link: layerLink,
                showWhenUnlinked: false,
                offset: const Offset(0, 80),
                child: Material(
                  color: Colors.transparent,
                  child: SizedBox(width: _searchWidth, child: _dropdown()),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  void hideOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void onSearch(String value, WidgetRef ref) async {
    if (value.isEmpty) {
      // Clear filtered list and load all packages
      ref.read(filteredListProvider.notifier).clearList();

      showOverlay();
      return;
    }
    try {
      final homeController = ref.read(homeProvider.notifier);
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
        final searchResponse = await homeController.searchPackages(search: value);
        if (searchResponse?.data != null) {
          ref.read(filteredListProvider.notifier).updateList(searchResponse!.data);
        }
      });
      showOverlay();
    } catch (e) {
      // If search fails, clear the filtered list
      ref.read(filteredListProvider.notifier).clearList();
    }
  }

  Widget _dropdown() {
    return Consumer(
      builder: (context, ref, child) {
        List<CountryPackage> list = ref.watch(filteredListProvider);
        return Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black.withValues(alpha: .15))],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text('Most Popular Destinations', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    final item = list[index];
                    return InkWell(
                      onTap: () {
                        controller.text = item.country;
                        focusNode.unfocus();
                        hideOverlay();
                        context.pushNamed(RouterNames.viewDetails, queryParameters: {"id": item.id.toString()});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                        child: Row(
                          children: [
                            if (item.coverPhoto.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: CachedNetworkImage(
                                  imageUrl: item.coverPhoto,
                                  fit: BoxFit.cover,
                                  height: 40,
                                  width: 56,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey.shade300,
                                    child: const Center(child: CircularProgressIndicator()),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 48),
                                  ),
                                ),
                              )
                            else
                              Container(
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.image, color: Colors.grey, size: 48),
                              ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.subtitle,
                                  style: context.bodyLarge?.copyWith(
                                    color: AppColors.darkTextColor,
                                    fontSize: 14,
                                    fontFamily: FontFamily.outfitRegular,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    hideOverlay();
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return SizedBox(
          key: _searchKey, // 👈 IMPORTANT
          width: 30.w,
          child: CompositedTransformTarget(
            link: layerLink,
            child: AppTextFormField(
              hint: "Search for a destination...",
              prefixIcon: Icons.search,
              controller: controller,
              onChanged: (value) => onSearch(value, ref),
              onTap: showOverlay,
              title: '',
            ),
          ),
        );
      },
    );
  }
}
