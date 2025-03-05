import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// Shimmer Loading Effect
Widget shimmerWebHomePage(BuildContext context) {
  return SingleChildScrollView(
    child: Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          children: [
            _buildShimmerBox(height: 200, width: double.infinity), // Hero Section Placeholder
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.count(
                    crossAxisCount: _getResponsiveCategoryCount(context),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.0,
                    children: List.generate(7, (index) => _getCategoryBox()),
                  );
                },
              ),
            ),
            SizedBox(
              height: 500, // Fixed height instead of Expanded
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _getResponsiveGridCount(context),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: 6,
                itemBuilder: (context, index) => _buildShimmerBox(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// A single shimmer loading box
Widget _buildShimmerBox({double height = 150, double width = double.infinity}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[300], // Remove white
      ),
    ),
  );
}

// Responsive Grid Count
int _getResponsiveGridCount(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth > 1600) return 5;
  if (screenWidth > 1400) return 4;
  if (screenWidth > 1000) return 3;
  if (screenWidth > 600) return 2;
  return 1;
}

// Responsive Category Count - Fixed Logical Error
int _getResponsiveCategoryCount(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth > 1400) return 7;
  if (screenWidth > 1000) return 4;
  if (screenWidth > 600) return 3;
  return 2;
}

// Category Placeholder Box with Shimmer
Widget _getCategoryBox() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
