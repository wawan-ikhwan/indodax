class Trade {
  final int timestamp;
  final num price;
  final num amount;
  final int tid;
  final String type;
  Trade(
      {required this.timestamp,
      required this.price,
      required this.amount,
      required this.tid,
      required this.type});
}
