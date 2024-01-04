import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';
import 'package:my_pup_simple/src/constants/app_sizes.dart';
import 'package:intl/intl.dart';

class DateFieldWidget extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  final ValueChanged<String> onChanged;

  const DateFieldWidget({
    Key? key,
    this.maxLines = 1,
    required this.label,
    required this.text,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<DateFieldWidget> createState() => _DateFieldWidgetState();
}

class _DateFieldWidgetState extends State<DateFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          gapH8,
          TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.date_range,
                color: mainAppColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: mainAppColor),
              ),
            ),
            maxLines: widget.maxLines,
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(
                  DateTime.now().year - 35,
                ), // max age for dogs set to 35
                lastDate: DateTime(DateTime.now().year + 1),
              );

              if (pickedDate != null) {
                if (kDebugMode) {
                  print(
                    pickedDate,
                  );
                } // pickedDate output format => 2021-03-10 00:00:00.000
                final formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                if (kDebugMode) {
                  print(formattedDate);
                } // formatted date output using intl package => 2021-03-16

                setState(() {
                  controller.text =
                      formattedDate; // set output date to TextField value.
                });
              } else {
                if (kDebugMode) {
                  print('Date is not selected');
                }
              }
            },
            onChanged: (date) => {print('date changed')},
          ),
        ],
      );
}
