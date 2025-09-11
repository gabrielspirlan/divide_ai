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

    return Card(
      color: const Color.fromRGBO(37, 37, 37, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(icon, color: textColor, size: 26),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TransactionTitleAndBadge(title, typeLabel, badgeColor),
                  TransactionParticipants(type, participants),
                  TransactionDate(date),
                ],
              ),
            ),
            Value(value, type, participants),
          ],
        ),
      ),
    );
  }
}

class TransactionParticipants extends StatelessWidget {
  final TransactionType _type;
  final List<String> _participants;

  TransactionParticipants(this._type, this._participants);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(
      _type == TransactionType.individual
          ? "Gasto de ${_participants.first}"
          : _participants.join(', '),
      style: const TextStyle(
        fontSize: 14,
        color: Color.fromRGBO(200, 200, 200, 1),
      ),
    );
  }
}

class TransactionDate extends StatelessWidget {
  final DateTime _date;

  TransactionDate(this._date);

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat("d 'de' MMM", "pt_BR").format(_date);
    return Row(
      children: [
        const Icon(
          HugeIcons.strokeRoundedCalendar04,
          size: 13,
          color: Colors.grey,
        ),
        const SizedBox(width: 4),
        Text(
          dateFormatted,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
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
    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final valuePerPerson = _type == TransactionType.compartilhado
        ? _value / _participants.length
        : _value;
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

class TransactionTitleAndBadge extends StatelessWidget {
  final String _title;
  final String _typeLabel;
  final Color _badgeColor;

  TransactionTitleAndBadge(this._title, this._typeLabel, this._badgeColor);

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
