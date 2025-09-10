import 'package:flutter/material.dart';

enum InfoCardSize { small, medium, large }
enum InfoCardAlignment { vertical, horizontal }

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final InfoCardSize size;
  final InfoCardAlignment alignment;

  const InfoCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    this.color = Colors.blue,
    this.size = InfoCardSize.medium,
    this.alignment = InfoCardAlignment.vertical,
  }) : super(key: key);

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

    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: isVertical
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: _getFontSizeValue() + 8),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: _getFontSizeTitle(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: _getFontSizeValue(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: _getFontSizeValue() + 8),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontSize: _getFontSizeTitle(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        color: color,
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
