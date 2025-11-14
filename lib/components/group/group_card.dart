import 'package:divide_ai/models/data/group_api_model.dart';
import 'package:divide_ai/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hugeicons/hugeicons.dart';

class GroupCard extends StatelessWidget {
  final GroupApiModel group;
  final VoidCallback? onTap;

  const GroupCard(this.group, {super.key, this.onTap});


  Color _parseColor(String hexColor) {
    hexColor = hexColor.replaceFirst('#', '');
    if (hexColor.length == 6) hexColor = 'FF$hexColor';
    return Color(int.parse(hexColor, radix: 16));
  }

  // Extrai apenas o primeiro nome de cada participante
  String _getFirstName(String fullName) {
    return fullName.trim().split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    final participantsShow = (group.participantNames ?? []).isEmpty
        ? 'Sem participantes'
        : group.participantNames!.map((name) => _getFirstName(name)).join(', ');

    final totalGroupValue = group.totalTransactions ?? 0.0;

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        final route = ModalRoute.of(context);
        final pageName = route?.settings.name ?? 'home_group_screen';
        AnalyticsService.trackEvent(
          elementId: group.name.toLowerCase().replaceAll(' ', '_'),
          eventType: 'CLICK',
          page: pageName,
        );
        onTap?.call();
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Theme.of(context).colorScheme.onBackground,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      IconBox(
                        HugeIcons.strokeRoundedUserMultiple02,
                        Colors.white,
                        _parseColor(group.backgroundIconColor),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GroupInfos(
                          group.name,
                          group.description,
                          participantsShow,
                        ),
                      ),
                    ],
                  ),
                ),
                GroupPriceItem(totalGroupValue),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IconBox extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const IconBox(this.icon, this.iconColor, this.backgroundColor, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: iconColor, size: 28),
    );
  }
}

class GroupInfos extends StatelessWidget {
  final String name;
  final String description;
  final String people;

  const GroupInfos(this.name, this.description, this.people, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18.0),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Text(
          description,
          style: const TextStyle(fontSize: 14.0, color: Colors.grey),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 2),
        Text(
          people,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(fontSize: 12.0, color: Colors.grey),
        ),
      ],
    );
  }
}

class GroupPriceItem extends StatelessWidget {
  final double value;

  const GroupPriceItem(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formatter.format(value),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        const Text(
          "total",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
