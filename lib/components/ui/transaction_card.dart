import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TransactionType { individual, compartilhado }

class TransactionCard extends StatelessWidget {
  final String title;
  final double value;
  final DateTime date;
  final List<String> participants;
  final TransactionType type;
  final Color? color;

  const TransactionCard({
    Key? key,
    required this.title,
    required this.value,
    required this.date,
    required this.participants,
    required this.type,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final dateFormatted = DateFormat("d 'de' MMM", "pt_BR").format(date);

    // Define ícone e cor padrão baseado no tipo
    final IconData icon = type == TransactionType.individual
        ? FontAwesomeIcons.user
        : FontAwesomeIcons.userGroup;

    final Color badgeColor = type == TransactionType.individual
        ? Colors.green
        : Colors.blue;

    final String typeLabel = type == TransactionType.individual
        ? "Individual"
        : "Compartilhado";

    // Caso seja compartilhado, calcular valor por pessoa
    final double valuePerPerson =
        type == TransactionType.compartilhado && participants.isNotEmpty
            ? value / participants.length
            : value;

    return Card(
      color: const Color.fromRGBO(37, 37, 37, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícone à esquerda
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (color ?? badgeColor).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color ?? badgeColor, size: 28),
            ),
            const SizedBox(width: 12),

            // Infos principais
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título + Badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: (color ?? badgeColor).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          typeLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: color ?? badgeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Participantes
                  Text(
                    type == TransactionType.individual
                        ? "Consumido por ${participants.first}"
                        : "Dividido entre ${participants.join(', ')}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color.fromRGBO(200, 200, 200, 1),
                    ),
                  ),

                  if (type == TransactionType.compartilhado)
                    Text(
                      "${participants.length} pessoas",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(160, 160, 160, 1),
                      ),
                    ),

                  const SizedBox(height: 6),

                  // Data
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        dateFormatted,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            // Valor
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatter.format(value),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (type == TransactionType.compartilhado)
                  Text(
                    "${formatter.format(valuePerPerson)} p/pessoa",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
