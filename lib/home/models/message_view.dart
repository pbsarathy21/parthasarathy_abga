abstract class MessageView {}

class MessageDetail extends MessageView {
  final String sender;
  final String date;
  final double amount;
  final String body;

  MessageDetail(this.sender, this.date, this.amount, this.body);
}

class MessageMonth extends MessageView {
  final String month;

  MessageMonth(this.month);
}

class MonthlyTotal extends MessageView {
  final double total;

  MonthlyTotal(this.total);
}
