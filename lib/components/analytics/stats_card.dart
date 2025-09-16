import 'package:flutter/material.dart';
import '../../models/enums/stats_type_enum.dart';
import 'package:hugeicons/hugeicons.dart';

class StatsCard extends StatelessWidget {
  final double value;

  final StatsTypeEnum type;

  const StatsCard({super.key, required this.value, required this.type});

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;
    String labelText;
    String valueText;
    double valueFontSize = 28;
    double cardHeight = 160;

    switch (type) {
      case StatsTypeEnum.loading:
        iconData = Icons.schedule;
        iconColor = const Color(0xFF60A5FA);
        labelText = 'Tempo médio';
        valueText = '${value.toInt()}ms';
        valueFontSize = 24;
        cardHeight = 170;
        break;
      case StatsTypeEnum.click:
        iconData = HugeIcons.strokeRoundedCursorPointer02;
        iconColor = const Color(0xFF4ADE80);
        labelText = 'Total cliques';
        valueText = value.toInt().toString();
        break;
      case StatsTypeEnum.visualization:
        iconData = Icons.trending_up;
        iconColor = const Color(0xFFC084FC);
        labelText = 'Visualizações';
        valueText = value.toInt().toString();
        break;
    }

    return Container(
      width: 130,
      height: cardHeight,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.withAlpha(51), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(iconData, color: iconColor, size: 32.0),

          Text(
            valueText,
            style: TextStyle(
              color: Colors.white,
              fontSize: valueFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            labelText,
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ],
      ),
    );
  }
}
