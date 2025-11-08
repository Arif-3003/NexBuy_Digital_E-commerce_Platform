import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utility/constants.dart';

class CustomDatePicker extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final void Function(DateTime) onDateSelected;

  const CustomDatePicker({
    Key? key,
    required this.labelText,
    required this.controller,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2697FF), // Header, active day, and OK button
              onPrimary: Colors.white, // Text on the blue background
              onSurface: Colors.black, // Regular text color (month/day numbers)
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF2697FF), // ✅ Force "OK"/"Cancel" text color
                textStyle: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            dialogBackgroundColor: Colors.white, // Dialog background
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != widget.initialDate) {
      setState(() {
        widget.controller.text = DateFormat('yyyy-MM-dd').format(picked);
        widget.onDateSelected(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.labelText,
          suffixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        readOnly: true,
        onTap: () => _selectDate(context),
      ),
    );
  }
}
