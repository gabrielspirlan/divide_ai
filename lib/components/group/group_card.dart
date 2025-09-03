import 'package:divide_ai/theme/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';

class GroupCard extends StatelessWidget {
  final String name;
  final String description;
  final String people;
  final double value;
  final int items;
  IconData? icon;
  Color? backgroundColor;
  Color? iconColor;

  GroupCard(
    this.name,
    this.description,
    this.people,
    this.value,
    this.items, {
    this.icon,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                icon ?? HugeIcons.strokeRoundedUserMultiple02,
                iconColor ??Colors.white,
                backgroundColor ?? Color.fromRGBO(21, 93, 252, 1),
              ),
              SizedBox(width: 10),
              GroupInfos(name, description, people),
              SizedBox(width: 10),
              GroupPriceItem(value, items),
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
