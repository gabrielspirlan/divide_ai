import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';

enum TransactionType { individual, compartilhado }

class TransactionCard extends StatelessWidget {
  final String title;
  final double value;
  final DateTime date;
  final List<String> participants;
  final TransactionType type;

  const TransactionCard({
    Key? key,
    required this.title,
    required this.value,
    required this.date,
    required this.participants,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final dateFormatted = DateFormat("d 'de' MMM", "pt_BR").format(date);

    final IconData icon = type == TransactionType.individual
        ? HugeIcons.strokeRoundedUserCheck02
        : HugeIcons.strokeRoundedUserMultiple03;

    final Color badgeColor = type == TransactionType.individual
        ? Theme.of(context).colorScheme.onSecondaryFixed
        : Theme.of(context).colorScheme.onPrimaryFixed;

    final Color backgroundColor = type == TransactionType.individual
        ? Theme.of(context).colorScheme.onSecondary
        : Theme.of(context).colorScheme.onPrimary;

    final Color textColor = type == TransactionType.individual
        ? Theme.of(context).colorScheme.onSecondaryFixed
        : Theme.of(context).colorScheme.onPrimaryFixed;

    final String typeLabel = type == TransactionType.individual
        ? "Individual"
        : "Compartilhado";

    final double valuePerPerson =
        type == TransactionType.compartilhado && participants.isNotEmpty
        ? value / participants.length
        : value;

    return Card(
      color: const Color.fromRGBO(37, 37, 37, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone à esquerda
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(icon, color: textColor, size: 26),
            ),
            const SizedBox(width: 12),

            // Infos principais
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleAndBadge(title, typeLabel, badgeColor),
                  const SizedBox(height: 4),

                  // Participantes
                  Text(
                    type == TransactionType.individual
                        ? "Gasto de ${participants.first}"
                        : participants.join(', '),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(200, 200, 200, 1),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Data
                  Row(
                    children: [
                      const Icon(
                        HugeIcons.strokeRoundedCalendar04,
                        size: 13,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateFormatted,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Value extends StatelessWidget {
  final double _value;
  final TransactionType _type;
  final List<String> _participants;
  Value(this._value, this._type, this._participants);


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formatter.format(_value),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        if (_type == TransactionType.compartilhado)
          Text(
            "${formatter.format(valuePerPerson)} p/pessoa",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
      ],
    );
  }
}

class TitleAndBadge extends StatelessWidget {
  final String _title;
  final String _typeLabel;
  final Color _badgeColor;

  TitleAndBadge(this._title, this._typeLabel, this._badgeColor);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 30),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _badgeColor.withValues(alpha: 0.05),
            border: Border.all(color: _badgeColor, width: 0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _typeLabel,
            style: TextStyle(
              fontSize: 12,
              color: _badgeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
