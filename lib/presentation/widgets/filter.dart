import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';

class Filter extends StatelessWidget {
  final String? selectedValue;
  final List<String> options;
  final Function(String?) onChanged;
  final Function(bool) onSorted;
  final bool sorted;

  const Filter({
    super.key,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
    required this.onSorted,
    required this.sorted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 100,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap: () => _showFilterDialog(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                     Icon(
                      selectedValue == 'Tất cả'
                          ? PhosphorIconsBold.funnel
                          : PhosphorIconsBold.funnelX,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      selectedValue ?? 'Lọc',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextButton.icon(
              onPressed: () {
                onSorted(!sorted);
              },
              icon: Icon(
                sorted ? Icons.sort_by_alpha : Icons.sort,
                color: AppColors.primary,
                size: 20,
              ),
              label: const Text(
                'Sắp xếp',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showFilterDialog(BuildContext context) async {
    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Chọn bộ lọc'),
          children: options.map((String option) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(context, option),
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: selectedValue == option
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        );
      },
    );

    if (result != null) {
      onChanged(result);
    }
  }
}
