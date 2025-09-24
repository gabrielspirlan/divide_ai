import 'package:flutter/material.dart';
import '../../models/enums/color_selector_variant.dart';

class ColorSelector extends StatefulWidget {
  final ColorSelectorVariant variant;
  final Function(Color selectedColor) onColorSelected;

  const ColorSelector({
    super.key,
    required this.variant,
    required this.onColorSelected,
  });

  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  Color? _selectedColor;

  void _selectColor(Color newColor) {
    if (_selectedColor != newColor) {
      setState(() {
        _selectedColor = newColor;
      });
      widget.onColorSelected(newColor);
    }
  }

  String _getSelectedColorName(BuildContext context) {
    if (_selectedColor == Theme.of(context).colorScheme.primary) {
      return 'Azul';
    }
    if (_selectedColor == Theme.of(context).colorScheme.secondary) {
      return 'Verde';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    if (_selectedColor == null) {
      _selectedColor = (widget.variant == ColorSelectorVariant.azul)
          ? primaryColor
          : secondaryColor;
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onColorSelected(_selectedColor!);
      });
    }

    return Container(
      width: double.infinity, 
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.color_lens_outlined, color: Colors.grey[400]),
              const SizedBox(width: 8),
              Text(
                'Cor do grupo',
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildColorOption(primaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildColorOption(secondaryColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Cor selecionada: ${_getSelectedColorName(context)}',
              textAlign: TextAlign.center, 
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    final bool isSelected = (_selectedColor == color);

    return GestureDetector(
      onTap: () => _selectColor(color),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
          border: isSelected
              ? Border.all(color: Colors.white, width: 2)
              : Border.all(color: Colors.transparent, width: 2), 
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}