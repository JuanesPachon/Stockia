import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'stat_card.dart';

class DetailDropdown {
  final String label;
  final String value;
  final List<String> items;
  final Function(String) onChanged;

  DetailDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });
}

class DetailCard extends StatelessWidget {
  final String title;
  final List<DetailDropdown> dropdowns;
  final List<Map<String, String>> stats;

  const DetailCard({
    super.key,
    required this.title,
    required this.dropdowns,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.mainBlue, width: 2))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.mainBlue,
              border: Border(bottom: BorderSide(color: AppColors.mainBlue, width: 2))
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.mainWhite,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          ...dropdowns.asMap().entries.expand((entry) {
            int index = entry.key;
            DetailDropdown dropdown = entry.value;
            bool isLast = index == dropdowns.length - 1;
            
            List<Widget> widgets = [
              DropdownRow(
                label: dropdown.label, 
                value: dropdown.value,
                items: dropdown.items,
                onChanged: dropdown.onChanged,
                isLast: isLast,
              ),
            ];
            
            if (!isLast) {
              widgets.add(
                Container(
                  color: AppColors.mainWhite,
                  child: const Divider(
                    height: 1,
                    thickness: 2,
                    color: AppColors.mainBlue,
                    indent: 16,
                    endIndent: 16,
                  ),
                ),
              );
            }
            
            return widgets;
          }),
          
          ...stats.asMap().entries.map((entry) {
            Map<String, String> stat = entry.value;
            return StatCard(
              label: stat.keys.first,
              value: stat.values.first,
              isEven: true,
            );
          }),
        ],
      ),
    );
  }
}

class DropdownRow extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final Function(String) onChanged;
  final bool isLast;

  const DropdownRow({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.mainWhite,
        border: isLast ? Border(bottom: BorderSide(color: AppColors.mainBlue, width: 2)) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.mainBlue,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DropdownButton<String>(
                value: value,
                underline: const SizedBox(),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.mainBlue,
                  size: 24,
                ),
                style: const TextStyle(
                  color: AppColors.mainBlue,
                  fontSize: 16,
                ),
                alignment: AlignmentDirectional.centerEnd,
                items: items.map<DropdownMenuItem<String>>((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      textAlign: TextAlign.end,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    onChanged(newValue);
                  }
                },
                dropdownColor: AppColors.mainWhite,
              ),
            ],
          ),
        ],
      ),
    );
  }
}