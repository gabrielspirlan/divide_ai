import 'package:divide_ai/models/enums/transaction_type.dart';

class Spent {
  TransactionType transactionType;
  double value;

  Spent(this.transactionType, this.value);
}
