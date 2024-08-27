import 'package:flutter/material.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';

class CustomDropdown extends StatefulWidget {
  final String? labelText;
  final List<String> dropDownItems;
  final ValueSetter<String> onChanged;
  final double width;
  final double height;

  const CustomDropdown({
    Key? key,
    required this.labelText,
    required this.dropDownItems,
    required this.onChanged,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).appColors;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: DropdownButtonFormField<String>(
        value: _selectedValue,
        decoration: InputDecoration(
          fillColor: color.formFieldBorder,
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: color.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: color.formFieldBorder,
              width: 3, // Thicker border
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: color.formFieldBorder,
              width: 3, // Thicker border when focused
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 3,
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: color.formFieldBorder,
              width: 3, // Thicker border when enabled
            ),
          ),
        ),
        items: widget.dropDownItems.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedValue = value;
          });
          widget.onChanged(value!);
        },
      ),
    );
  }
}
