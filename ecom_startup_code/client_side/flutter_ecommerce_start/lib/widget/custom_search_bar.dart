import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputTheme = theme.inputDecorationTheme;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: inputTheme.fillColor ?? Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
          hintText: "Search...",
          hintStyle: inputTheme.hintStyle ?? TextStyle(color: theme.hintColor),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}
