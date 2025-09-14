import 'package:divide_ai/theme/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hugeicons/hugeicons.dart';

// Classe para salvar informações do grupo
class Group {
  final String name;
  final String description;
  final List<String> participants;
  final double value;
  final int items;
  final Color backgroundIconColor;

  Group(
    this.name, {
    required this.description,
    required this.participants,
    required this.value,
    required this.items,
    required this.backgroundIconColor,
  });
}

class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback? onTap;

  const GroupCard(this.group, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      splashColor: group.backgroundIconColor,
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Theme.of(context).colorScheme.onSurface,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: IntrinsicHeight(
            child: Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    spacing: 10,
                    children: [
                      IconBox(
                        HugeIcons.strokeRoundedUserMultiple02,
                        Colors.white,
                        group.backgroundIconColor,
                      ),
                      GroupInfos(
                        group.name,
                        group.description,
                        group.participants.join(', '),
                      ),
                    ],
                  ),
                ),
                GroupPriceItem(group.value, group.items),
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
      padding: EdgeInsets.all(12),
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
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18.0),
          overflow: TextOverflow.clip,
        ),
        Text(
          description,
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.grey,
          ),
          overflow: TextOverflow.clip,
        ),
        SizedBox(height: 2),
        Text(
          people,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.grey,
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }
}

class GroupPriceItem extends StatelessWidget {
  final double value;
  final int items;

  const GroupPriceItem(this.value, this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formatter.format(value),
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        Text(
          "$items itens",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
