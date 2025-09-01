import 'package:divide_ai/theme/AppTheme.dart';
import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(Icons.star, color: Colors.blue[600]),
        GroupInfos(
          "Hamburgueria",
          "Comanda da hamburgueria",
          "Luiz, Henrique, Gabriel",
        ),
        GroupPriceItem(159.00, 5),
      ],
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
    return Column(children: [Text(name), Text(description), Text(people)]);
  }
}

class GroupPriceItem extends StatelessWidget {
  final double value;
  final int items;

  GroupPriceItem(this.value, this.items);

  @override
  Widget build(BuildContext context) {
    return Column(children: [Text('R${value}'), Text("$items itens")]);
  }
}
