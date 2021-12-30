class Pair {
  final String id;
  final String symbol;
  final String baseCurrency;
  final String tradedCurrency;
  final String tradedCurrencyUnit;
  final String description;
  final String tickerID;
  final int volumePrecision;
  final int pricePrecision;
  final int priceRound;
  final int priceScale;
  final int tradeMinBaseCurrency;
  final num tradeMinTradedCurrency;
  final bool hasMemo;
  final String memoName;
  final num tradeFeePercent;
  final String urlLogo;
  final String urlLogoPNG;
  final int isMaintenance;

  Pair(
      {required this.id,
      required this.symbol,
      required this.baseCurrency,
      required this.tradedCurrency,
      required this.tradedCurrencyUnit,
      required this.description,
      required this.tickerID,
      required this.volumePrecision,
      required this.pricePrecision,
      required this.priceRound,
      required this.priceScale,
      required this.tradeMinBaseCurrency,
      required this.tradeMinTradedCurrency,
      required this.hasMemo,
      required this.memoName,
      required this.tradeFeePercent,
      required this.urlLogo,
      required this.urlLogoPNG,
      required this.isMaintenance});
}
