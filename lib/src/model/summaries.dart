import 'ticker.dart';

class Summaries {
  final List<Ticker> tickers;
  final Map<String, dynamic> prices24h;
  final Map<String, dynamic> prices7d;
  Summaries(
      {required this.tickers, required this.prices24h, required this.prices7d});
}
