import 'package:divide_ai/theme/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';

class GroupCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconBox(
                HugeIcons.strokeRoundedUserMultiple02,
                Colors.white,
                Color.fromRGBO(21, 93, 252, 1),
              ),
              SizedBox(width: 10),
              GroupInfos(
                "Hamburgueria",
                "Comanda da hamburgueria",
                "Luiz, Henrique, Gabriel",
              ),
              SizedBox(width: 10),
              GroupPriceItem(159.00, 5),
            ],
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
        borderRadius: BorderRadius.circular(12),
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
