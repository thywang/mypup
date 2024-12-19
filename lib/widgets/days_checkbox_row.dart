import 'package:flutter/material.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';

class DaysCheckboxRow extends StatefulWidget {
  const DaysCheckboxRow({
    required this.selectedDays,
    required this.onChanged,
    super.key,
  });

  final List<bool> selectedDays;
  final ValueChanged<List<bool>> onChanged;

  @override
  State<DaysCheckboxRow> createState() => _DaysCheckboxRowState();
}

class _DaysCheckboxRowState extends State<DaysCheckboxRow> {
  static const List<String> dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: dayLabels
          .asMap()
          .map(
            (index, label) => MapEntry(
              index,
              _buildDayCheckbox(index, label),
            ),
          )
          .values
          .toList(),
    );
  }

  Widget _buildDayCheckbox(int index, String dayLabel) {
    return 
      GestureDetector(
        onTap: () {
          setState(() {
            widget.selectedDays[index] = !widget.selectedDays[index];
          });
          widget.onChanged(widget.selectedDays);
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.selectedDays[index]
                ? mainAppColor.withOpacity(0.2)
                : Colors.transparent, // background color
            borderRadius:
                BorderRadius.circular(8),
            border: Border.all(
              color: widget.selectedDays[index]
                  ? mainAppColor
                  : grayTextColor,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: widget.selectedDays[index],
                onChanged: (bool? value) {
                  setState(() {
                    widget.selectedDays[index] = value!;
                  });
                },
                activeColor: mainAppColor,
                side: BorderSide(width: 2, color: grayTextColor),
              ),
              Text(
                dayLabel,
                style: TextStyle(
                  color: widget.selectedDays[index]
                      ? mainAppColor
                      : grayTextColor, // Text color based on selection
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
    );
  }
}
