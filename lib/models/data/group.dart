import 'package:divide_ai/models/data/user.dart';
import 'package:flutter/material.dart';

class Group {
  static int _nextId = 1;
  final int id;
  final String name;
  final String description;
  final List<int> participantIds;
  final double value;
  final Color backgroundIconColor;

  Group(
    this.name, {
    required this.description,
    required this.participantIds,
    required this.value,
    required this.backgroundIconColor,
  }) : id = _nextId++;
}

List<Group> groups = [
  Group(
    "Bahia Lanches",
    description: "Lanches no Bahia Lanches",
    participantIds: [1, 2, 3, 4],
    value: 260.00,
    backgroundIconColor: Colors.blue,
  ),
  Group(
    "Espetinho",
    description: "Espetinho da Fatec",
    participantIds: [1, 2, 3, 4],
    value: 80.00,
    backgroundIconColor: Colors.red,
  ),
];
