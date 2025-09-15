import 'package:flutter/material.dart';

enum InfoCardSize { small, medium, large }
enum InfoCardAlignment { vertical, horizontal }
enum InfoCardColor { blue, green }

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final InfoCardSize size;
  final InfoCardAlignment alignment;
  final InfoCardColor colorOption;

  const InfoCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    this.size = InfoCardSize.medium,
    this.alignment = InfoCardAlignment.vertical,
    this.colorOption = InfoCardColor.blue, 
  }) : super(key: key);

  Color _getColor(BuildContext context) {
    switch (colorOption) {
      case InfoCardColor.green:
        return const Color(0xFF00C950); 
      case InfoCardColor.blue:
        return const Color(0xFF2B7FFF); 
    }
  }

  double _getFontSizeTitle() {
    switch (size) {
      case InfoCardSize.small:
        return 12;
      case InfoCardSize.medium:
        return 14;
      case InfoCardSize.large:
        return 16;
    }
  }

  double _getFontSizeValue() {
    switch (size) {
      case InfoCardSize.small:
        return 14;
      case InfoCardSize.medium:
        return 16;
      case InfoCardSize.large:
        return 20;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case InfoCardSize.small:
        return const EdgeInsets.all(8);
      case InfoCardSize.medium:
        return const EdgeInsets.all(12);
      case InfoCardSize.large:
        return const EdgeInsets.all(16);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVertical = alignment == InfoCardAlignment.vertical;
    final Color cardColor = _getColor(context);

    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardColor, width: 1.5),
      ),
      child: isVertical
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: cardColor, size: _getFontSizeValue() + 8),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: TextStyle(
                    color: cardColor,
                    fontSize: _getFontSizeTitle(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: cardColor,
                    fontSize: _getFontSizeValue(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: cardColor, size: _getFontSizeValue() + 8),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: cardColor,
                        fontSize: _getFontSizeTitle(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        color: cardColor,
                        fontSize: _getFontSizeValue(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
