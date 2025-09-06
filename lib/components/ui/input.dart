import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum InputSize { small, medium, large }

class Input extends StatefulWidget {
  final String label;
  final String? hint;
  final IconData? icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final InputSize size;

  const Input({
    Key? key,
    required this.label,
    this.hint,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.controller,
    this.size = InputSize.medium,
  }) : super(key: key);

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    double height;
    double fontSize;
    switch (widget.size) {
      case InputSize.small:
        height = 40;
        fontSize = 14;
        break;
      case InputSize.medium:
        height = 50;
        fontSize = 16;
        break;
      case InputSize.large:
        height = 60;
        fontSize = 18;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize - 2,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: Color.fromRGBO(37, 37, 37, 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            style: TextStyle(color: Colors.white, fontSize: fontSize),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              prefixIcon: widget.icon != null
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: FaIcon(widget.icon, color: Colors.white),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
