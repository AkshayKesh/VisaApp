import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VisaSkeletonGrid extends StatelessWidget {
  const VisaSkeletonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount = width > 1200
        ? 4
        : width > 900
        ? 3
        : width > 600
        ? 2
        : 1;

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
       crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (_, _) => const VisaCardSkeleton(),
    );
  }
}

class VisaCardSkeleton extends StatelessWidget {
  const VisaCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Image placeholder
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
    
            // Badge
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                height: 24,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
    
            // Text section
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  Container(height: 12, width: 100, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
