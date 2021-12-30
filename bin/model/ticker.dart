class Ticker {
  final String id;
  final num high;
  final num low;
  final num volCrypto;
  final num volFiat;
  final num last;
  final num buy;
  final num sell;
  final num serverTime;
  final String? name;

  Ticker(
      {required this.id,
      required this.high,
      required this.low,
      required this.volCrypto,
      required this.volFiat,
      required this.last,
      required this.buy,
      required this.sell,
      required this.serverTime,
      required this.name});
}
