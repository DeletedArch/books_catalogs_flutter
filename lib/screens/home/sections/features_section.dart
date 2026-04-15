import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/feature.dart';
import '../../../widgets/feature_card.dart';

class FeaturesSection extends StatelessWidget {
  final List<AppFeature> features;

  const FeaturesSection({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.lightGrey,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        children: [
          const Text("Website's Features", style: AppTheme.sectionTitle),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) =>
                FeatureCard(feature: features[index]),
          ),
        ],
      ),
    );
  }
}
