import 'package:flutter/material.dart';
import 'package:xtrends/ux/model/ui_models.dart';
import 'package:xtrends/ux/shared/components/icon_box.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';

class AboutCard extends StatelessWidget {
  const AboutCard({super.key, required this.item});

  final AboutItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBox(
                icon: item.icon,
                backgroundColor: AppColors.primary50,
              ),
              const SizedBox(width: 10),
              Text(
                item.title,
                style: const TextStyle(
                    color: AppColors.darkBlueText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(height: 16),
          Text(
            item.detail,
            textAlign: TextAlign.justify,
            style: const TextStyle(
                color: AppColors.grey400, fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}
