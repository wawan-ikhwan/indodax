import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../model/depth.dart';
import '../model/price_increment.dart';
import '../model/pair.dart';
import '../model/server_time.dart';
import '../model/summaries.dart';
import '../model/ticker.dart';
import '../model/trade.dart';

class PublicAPI {
  static var _client = http.Client();

  static void open() {
    close();
    _client = http.Client();
  }

  static void close() {
    _client.close();
  }

  static Future<Map<String, dynamic>> _fetch(final String path) async {
    final url = Uri.https('indodax.com', path);
    final response = await _client.get(url);
    return convert.jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<ServerTime> get serverTime async {
    final jsonResponse = await _fetch('api/server_time');
    return ServerTime(
        timeZone: jsonResponse['timezone'], time: jsonResponse['server_time']);
  }

  static Future<List<Pair>> get pairs async {
    final jsonResponse = await _fetch('api/pairs') as List;
    final List<Pair> listModel = jsonResponse
        .map((p) => Pair(
            id: p['id'],
            symbol: p['symbol'],
            baseCurrency: p['base_currency'],
            tradedCurrency: p['traded_currency'],
            tradedCurrencyUnit: p['traded_currency_unit'],
            description: p['description'],
            tickerID: p['ticker_id'],
            volumePrecision: p['volume_precision'],
            pricePrecision: p['price_precision'],
            priceRound: p['price_round'],
            priceScale: p['pricescale'],
            tradeMinBaseCurrency: p['trade_min_base_currency'],
            tradeMinTradedCurrency: p['trade_min_traded_currency'],
            hasMemo: p['has_memo'] == 'true',
            memoName: p['memo_name'],
            tradeFeePercent: p['trade_fee_percent'],
            urlLogo: p['url_logo'],
            urlLogoPNG: p['url_logo_png'],
            isMaintenance: p['is_maintenance']))
        .toList();
    return listModel;
  }

  static Future<List<PriceIncrement>> get priceIncrements async {
    final jsonResponse = await _fetch('api/price_increments');
    final Map<String, dynamic> increments = jsonResponse['increments'];
    final List<PriceIncrement> listModel = increments.entries
        .map((MapEntry mapEntry) => PriceIncrement(
            tickerID: mapEntry.key, val: num.parse(mapEntry.value)))
        .toList();
    return listModel;
  }

  static Future<Ticker> getTicker({final String id = 'btc_idr'}) async {
    final List listCurrency = id.split('_');
    final String crypto = listCurrency[0];
    final String fiat = listCurrency[1];
    final jsonResponse = await _fetch('api/ticker/$crypto$fiat');
    final Map<String, dynamic> ticker = jsonResponse['ticker'];
    return Ticker(
        id: id,
        high: num.parse(ticker['high']),
        low: num.parse(ticker['low']),
        volCrypto: num.parse(ticker['vol_$crypto']),
        volFiat: num.parse(ticker['vol_$fiat']),
        last: num.parse(ticker['last']),
        buy: num.parse(ticker['buy']),
        sell: num.parse(ticker['sell']),
        serverTime: ticker['server_time'],
        name: ticker['name']);
  }

  static Future<List<Ticker>> get tickerAll async {
    final jsonResponse = await _fetch('api/ticker_all');
    final Map<String, dynamic> tickers = jsonResponse['tickers'];
    final List<Ticker> listModel = tickers.entries.map((MapEntry m) {
      final List listCurrency = m.key.split('_');
      final String crypto = listCurrency[0];
      final String fiat = listCurrency[1];
      return Ticker(
          id: m.key,
          high: num.parse(m.value['high']),
          low: num.parse(m.value['low']),
          volCrypto: num.parse(m.value['vol_$crypto']),
          volFiat: num.parse(m.value['vol_$fiat']),
          last: num.parse(m.value['last']),
          buy: num.parse(m.value['buy']),
          sell: num.parse(m.value['sell']),
          serverTime: m.value['server_time'],
          name: m.value['name']);
    }).toList();
    return listModel;
  }

  static Future<Summaries> get summaries async {
    final jsonResponse = await _fetch('api/summaries');
    final Map<String, dynamic> tickers = jsonResponse['tickers'];
    final List<Ticker> listTickers = tickers.entries.map((MapEntry m) {
      final List listCurrency = m.key.split('_');
      final String crypto = listCurrency[0];
      final String fiat = listCurrency[1];
      return Ticker(
          id: m.key,
          high: num.parse(m.value['high']),
          low: num.parse(m.value['low']),
          volCrypto: num.parse(m.value['vol_$crypto']),
          volFiat: num.parse(m.value['vol_$fiat']),
          last: num.parse(m.value['last']),
          buy: num.parse(m.value['buy']),
          sell: num.parse(m.value['sell']),
          serverTime: m.value['server_time'],
          name: m.value['name']);
    }).toList();
    return Summaries(
        tickers: listTickers,
        prices24h: jsonResponse['prices_24h'],
        prices7d: jsonResponse['prices_7d']);
  }

  static Future<List<Trade>> getTrade({final String id = 'btc_idr'}) async {
    final List listCurrency = id.split('_');
    final String crypto = listCurrency[0];
    final String fiat = listCurrency[1];
    final jsonResponse = await _fetch('api/trades/$crypto$fiat') as List;
    final List<Trade> listModel = jsonResponse
        .map((t) => Trade(
            timestamp: int.parse(t['date']),
            price: num.parse(t['price']),
            amount: num.parse(t['amount']),
            tid: int.parse(t['tid']),
            type: t['type']))
        .toList();
    return listModel;
  }

  static Future<Depth> getDepth({final String id = 'btc_idr'}) async {
    final List listCurrency = id.split('_');
    final String crypto = listCurrency[0];
    final String fiat = listCurrency[1];
    final jsonResponse = await _fetch('api/depth/$crypto$fiat');
    final List<dynamic> buy = jsonResponse['buy'];
    final List<dynamic> sell = jsonResponse['sell'];
    return Depth(buy: buy, sell: sell);
  }
}
