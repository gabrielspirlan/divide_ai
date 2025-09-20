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
    final colorScheme = Theme.of(context).colorScheme;
    final isVertical = alignment == InfoCardAlignment.vertical;

    final Color backgroundColor = colorOption == InfoCardColor.blue
        ? colorScheme.primaryContainer
        : colorScheme.secondaryContainer;

    final Color textColor = colorOption == InfoCardColor.blue
        ? colorScheme.onPrimaryFixed
        : colorScheme.onSecondaryFixed;

    final Color boldTextColor = colorOption == InfoCardColor.blue
        ? colorScheme.inversePrimary
        : colorScheme.onSecondaryFixed;

    return Card(
      color: backgroundColor,

      child: Padding(
        padding: EdgeInsets.all(10),
        child: isVertical
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: textColor, size: _getFontSizeValue() + 8),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: _getFontSizeTitle(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      color: boldTextColor,
                      fontSize: _getFontSizeValue(),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Icon(icon, color: textColor, size: _getFontSizeValue() + 8),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: _getFontSizeTitle(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        value,
                        style: TextStyle(
                          color: boldTextColor,
                          fontSize: _getFontSizeValue(),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
