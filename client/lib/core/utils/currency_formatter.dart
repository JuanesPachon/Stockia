import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _formatter = NumberFormat('#,##0', 'es_CO');

  static String formatCOP(double amount) {
    return '\$${_formatter.format(amount.round())}';
  }

  static String formatCOPFromInt(int amount) {
    return '\$${_formatter.format(amount)}';
  }
}