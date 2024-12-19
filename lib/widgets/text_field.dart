import 'package:flutter/material.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';
import 'package:my_pup_simple/src/constants/app_sizes.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    required this.label,
    this.onChanged,
    this.text = '',
    this.hint = '',
    this.controller,
    this.trailingWidget,
    super.key,
    this.maxLines = 1,
  });

  final int maxLines;
  final String label;
  final String text;
  final String hint;
  final TextEditingController? controller;
  final Widget? trailingWidget;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          gapH8,
          Row(
            children: [
              Expanded(
                child: TextField(
                  readOnly: trailingWidget != null,
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: grayTextColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: trailingWidget,
                  ),
                  maxLines: maxLines,
                  onChanged: onChanged,
                ),
              ),
            ],
          )
        ],
      );
}
