import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:divide_ai/services/analytics_service.dart';

enum InputSize { small, medium, large }

class Input extends StatefulWidget {
  final String label;
  final String? hint;
  final IconData? icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final InputSize size;

  const Input(this.label, {
    super.key,
    this.hint,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.controller,
    this.size = InputSize.medium,
  });

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
        if (_isFocused) {
          _trackInputFocus();
        }
      });
    });
  }

  void _trackInputFocus() {
    final route = ModalRoute.of(context);
    final pageName = route?.settings.name ?? 'unknown_page';
    AnalyticsService.trackEvent(
      elementId: widget.label.toLowerCase().replaceAll(' ', '_'),
      eventType: 'CLICK',
      page: pageName,
    );
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
        Row(
          children: [
            if (widget.icon != null) ...[
              FaIcon(
                widget.icon,
                color: Colors.white,
                size: iconSize,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              widget.label,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: fontSize - 2,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: height,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isFocused
                  ? Theme.of(context).focusColor
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}
