import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';

enum TransactionType { individual, compartilhado }

class Transaction {
  final String title;
  final double value;
  final DateTime date;
  final List<String> participants;
  final TransactionType type;

  Transaction({
    required this.title,
    required this.value,
    required this.date,
    required this.participants,
    required this.type,
  });
}

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  TransactionCard(this.transaction);

  @override
  Widget build(BuildContext context) {
    final IconData icon = transaction.type == TransactionType.individual
        ? HugeIcons.strokeRoundedUserCheck02
        : HugeIcons.strokeRoundedUserMultiple03;

    final Color badgeColor = transaction.type == TransactionType.individual
        ? Theme.of(context).colorScheme.onSecondaryFixed
        : Theme.of(context).colorScheme.onPrimaryFixed;

    final Color backgroundColor = transaction.type == TransactionType.individual
        ? Theme.of(context).colorScheme.onSecondary
        : Theme.of(context).colorScheme.onPrimary;

    final Color textColor = transaction.type == TransactionType.individual
        ? Theme.of(context).colorScheme.onSecondaryFixed
        : Theme.of(context).colorScheme.onPrimaryFixed;

    return Card(
      color: Theme.of(context).colorScheme.onBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TransactionIcon(backgroundColor, textColor, icon),
            Expanded(
              child: Column(
                spacing: 3,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TransactionTitle(
                    transaction.title
                  ),

                  TransactionParticipants(
                    transaction.type,
                    transaction.participants,
                  ),
                  TransactionDate(transaction.date),
                ],
              ),
            ),
            TransactionValueAndBadge(
              transaction.value,
              transaction.type,
              transaction.participants,
              badgeColor,
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionIcon extends StatelessWidget {
  final Color _backgroundColor;
  final Color _textColor;
  final IconData _icon;

  TransactionIcon(this._backgroundColor, this._textColor, this._icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(_icon, color: _textColor, size: 26),
    );
  }
}

class TransactionParticipants extends StatelessWidget {
  final TransactionType _type;
  final List<String> _participants;

  TransactionParticipants(this._type, this._participants);

  @override
  Widget build(BuildContext context) {
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

class TransactionValueAndBadge extends StatelessWidget {
  final double _value;
  final TransactionType _type;
  final List<String> _participants;
  final Color _badgeColor;

  TransactionValueAndBadge(
    this._value,
    this._type,
    this._participants,
    this._badgeColor,
  );

  @override
  Widget build(BuildContext context) {
    final String typeLabel = _type == TransactionType.individual
        ? "Individual"
        : "Compartilhado";

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
        Container(
          margin: EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _badgeColor.withAlpha(1),
            border: Border.all(color: _badgeColor, width: 0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            typeLabel,
            style: TextStyle(
              fontSize: 11,
              color: _badgeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class TransactionTitle extends StatelessWidget {
  final String _title;

  TransactionTitle(this._title);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 30,
      children: [
        Text(
          _title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
