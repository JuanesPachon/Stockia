import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class DefaultDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? hintText;

  const DefaultDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.mainBlue,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 205, 187, 152),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.mainBlue,
              width: 1.5,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(value) ? value : null,
              isDense: true,
              hint: hintText != null
                  ? Text(
                      hintText!,
                      style: const TextStyle(
                        color: AppColors.mainBlue,
                        fontSize: 16,
                      ),
                    )
                  : null,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.mainBlue,
              ),
              style: const TextStyle(
                color: AppColors.mainBlue,
                fontSize: 16,
              ),
              dropdownColor: const Color.fromARGB(255, 205, 187, 152),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}