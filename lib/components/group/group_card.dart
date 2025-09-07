import 'package:divide_ai/theme/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hugeicons/hugeicons.dart';

// Classe para salvar informações do grupo
class Group {
  final String name;
  final String description;
  final String people;
  final double value;
  final int items;
  final Color backgroundColor;

  Group(
    this.name,
    this.description,
    this.people,
    this.value,
    this.items,
    this.backgroundColor,
  );
}

class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback? onTap;

  GroupCard(this.group, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      splashColor: group.backgroundColor,
      onTap: onTap,
      child: Card(
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color.fromRGBO(37, 37, 37, 1),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: IntrinsicHeight(
            child: Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconBox(
                  HugeIcons.strokeRoundedUserMultiple02,
                  Colors.white,
                  group.backgroundColor,
                ),
                SizedBox(width: 10),
                GroupInfos(group.name, group.description, group.people),
                SizedBox(width: 10),
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

  IconBox(this.icon, this.iconColor, this.backgroundColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, color: iconColor, size: 32),
    );
  }
}

class GroupInfos extends StatelessWidget {
  final String name;
  final String description;
  final String people;

  GroupInfos(this.name, this.description, this.people);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18.0),
        ),
        Text(
          description,
          style: TextStyle(
            fontSize: 14.0,
            color: Color.fromRGBO(160, 160, 160, 1),
          ),
        ),
        Text(
          people,
          style: TextStyle(
            fontSize: 14.0,
            color: Color.fromRGBO(160, 160, 160, 1),
          ),
        ),
      ],
    );
  }
}

class GroupPriceItem extends StatelessWidget {
  final double value;
  final int items;

  GroupPriceItem(this.value, this.items);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return Column(
      spacing: 2,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formatter.format(value),
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        Text(
          "$items itens",
          style: TextStyle(
            color: Color.fromRGBO(160, 160, 160, 1),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
