import 'package:flutter/material.dart';

class Bill {
  final String participantName;
  final double valueIndividual;
  final double valueCompartilhado;

  Bill(
    this.participantName, {
    required this.valueCompartilhado,
    required this.valueIndividual,
  });
}
