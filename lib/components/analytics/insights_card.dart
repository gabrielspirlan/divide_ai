import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../models/enums/stats_type_enum.dart';

class InsightsCard extends StatelessWidget {
  final StatsTypeEnum type;
  final String insightTargetName;
  final double actionCount;

  const InsightsCard({
    super.key,
    required this.type,
    required this.insightTargetName,
    required this.actionCount,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    String subtitle;
    IconData iconData;
    Color iconColor;
    
    switch (type) {
      case StatsTypeEnum.loading:
        title = 'Página mais lenta';
        subtitle = '$insightTargetName - ${actionCount.toStringAsFixed(1)}s';
        iconData = Icons.schedule; 
        iconColor = Colors.red[400]!; 
        break;
      case StatsTypeEnum.click:
        title = 'Botão mais clicado';
        subtitle = '$insightTargetName - ${actionCount.toInt()} cliques';
        iconData = HugeIcons.strokeRoundedCursorPointer02; 
        iconColor = const Color(0xFF4ADE80);
        break;
      case StatsTypeEnum.visualization:
        title = 'Página mais acessada';
        subtitle = '$insightTargetName - ${actionCount.toInt()} visualizações';
        iconData = Icons.trending_up;
        iconColor = const Color(0xFFC084FC);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12.0),
        border: Border(
          top: BorderSide(
            color: Colors.white.withAlpha(20),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(iconData, color: iconColor, size: 32.0),
        ],
      ),
    );
  }
}