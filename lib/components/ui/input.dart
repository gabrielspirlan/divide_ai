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
  late double height;
  late double fontSize;
  late double iconSize;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.size) {
      case InputSize.small:
        height = 40;
        fontSize = 14;
        iconSize = 16;
        break;
      case InputSize.medium:
        height = 50;
        fontSize = 16;
        iconSize = 20;
        break;
      case InputSize.large:
        height = 60;
        fontSize = 18;
        iconSize = 24;
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
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF2a2a2a),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isFocused
                  ? const Color(0xFF6a6a6a)
                  : Color(0xFF3a3a3a),
              width: 2,
            ),
          ),
          child: Center( 
            child: TextField(
              focusNode: _focusNode,
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white, fontSize: fontSize),
              textAlignVertical: TextAlignVertical.center, // cursor centralizado
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                hintText: widget.hint,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                prefixIcon: widget.icon != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: FaIcon(widget.icon,
                            color: Colors.white, size: iconSize),
                      )
                    : null,
                prefixIconConstraints: BoxConstraints(
                  minWidth: iconSize + 20,
                  minHeight: iconSize,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
