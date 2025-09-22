import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pacote para formatar a data
import '../../models/enums/stats_type_enum.dart';

class DescribeStatsCard extends StatelessWidget {
  final String eventName;
  final DateTime eventDate;
  final StatsTypeEnum type;
  final double? loadingTime;

  const DescribeStatsCard({
    super.key,
    required this.eventName,
    required this.eventDate,
    required this.type,
    this.loadingTime,
  });

  @override
  Widget build(BuildContext context) {
    Widget rightSideWidget;

    if (type == StatsTypeEnum.loading) {
      // 👇 CORREÇÃO AQUI: A multiplicação por 1000 foi removida.
      // O valor agora é apenas convertido para inteiro.
      rightSideWidget = Text(
        '${(loadingTime ?? 0).toInt()}ms',
        style: const TextStyle(
          color: Color(0xFFE8B953),
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      );
    } else {
      Color circleColor;
      switch (type) {
        case StatsTypeEnum.click:
          circleColor = const Color(0xFF4ADE80);
          break;
        case StatsTypeEnum.visualization:
          circleColor = const Color(0xFFC084FC);
          break;
        default:
          circleColor = Colors.grey;
      }
      rightSideWidget = Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: circleColor,
          shape: BoxShape.circle,
        ),
      );
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eventName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('yyyy-MM-dd HH:mm:ss').format(eventDate),
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          rightSideWidget,
        ],
      ),
    );
  }
}