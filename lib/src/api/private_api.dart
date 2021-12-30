import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:universal_io/io.dart' as uio;

/// An API access that need authenticate which provides private info and actions like
/// [info], [getTransHistory], [getTradeHistory], [getOpenOrders]
/// [getOrderHistory], [getOrder], [cancelOrder], [trade], [close]
class PrivateAPI {
  String? key;
  String? secret;
  String? authPath;

  /// Auto create client interface whenever object created
  final _client = http.Client();

  PrivateAPI({this.secret, this.key, final this.authPath}) {
    try {
      var jsonAuth = convert.jsonDecode(uio.File(authPath!).readAsStringSync());
      key = jsonAuth['API'];
      secret = jsonAuth['SECRET'];
      if (secret == null || key == null) {
        throw ('key "API" atau "SECRET" pada file json tidak ditemukan!');
      }
    } catch (e) {
      if (secret == null || key == null) {
        throw (Exception(
            'Properties "secret" atau "key" kosong, atau bisa gunakan file "auth.json" yang valid!\n$e'));
      }
    }
  }

  /// Private method that handle signature every request
  static String _getSignature(
      {required final String secret, required final String data}) {
    final List<int> encodedSecret = convert.utf8.encode(secret);
    final List<int> encodedData = convert.utf8.encode(data);
    final String signature =
        Hmac(sha512, encodedSecret).convert(encodedData).toString();
    return signature;
  }

  /// Private method that doing request according specified body.
  Future<Map<String, dynamic>> _fetch(
      {required final Map<String, dynamic> badan}) async {
    // Validasi badan:
    badan['timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();
    badan.removeWhere((key, value) => value == null);
    final Map<String, String> encodedBadan =
        badan.map((key, value) => MapEntry(key, value.toString()));

    final Uri url = Uri.https('indodax.com', 'tapi');
    final response = await _client.post(url,
        headers: {
          'Key': key!,
          'Sign': _getSignature(
            secret: secret!,
            data: Uri(queryParameters: encodedBadan).query,
          )
        },
        body: encodedBadan);
    return convert.jsonDecode(response.body);
  }

  /// Get general info current trader.
  Future<Map<String, dynamic>> get info async {
    return await _fetch(
      badan: <String, dynamic>{
        'method': 'getInfo',
      },
    );
  }

  /// Get transaction history.
  Future<Map<String, dynamic>> getTransHistory(
      {final String? start, final String? end}) async {
    return await _fetch(
      badan: <String, dynamic>{
        'method': 'transHistory',
        'start': start,
        'end': end,
      },
    );
  }

  /// Do trade (open order or instant order)
  Future<Map<String, dynamic>> trade(
      {final String pair = 'btc_idr',
      final String type = 'buy',
      final num price = 1,
      final num? cryptoAmount,
      final num? fiatAmount}) async {
    final List listCurrency = pair.split('_');
    final String crypto = listCurrency[0];
    final String fiat = listCurrency[1];
    return await _fetch(
      badan: <String, dynamic>{
        'method': 'trade',
        'pair': pair,
        'type': type,
        'price': price,
        crypto: cryptoAmount,
        fiat: fiatAmount,
      },
    );
  }

  /// Get trading history.
  Future<Map<String, dynamic>> getTradeHistory({
    final String pair = 'btc_idr',
    final int count = 1000,
    final int fromID = 0,
    final int endID = 0,
    final String order = 'desc',
    final int? since,
    final int? end,
  }) async {
    return await _fetch(
      badan: <String, dynamic>{
        'method': 'tradeHistory',
        'pair': pair,
        'count': count,
        'from_id': fromID,
        'end_id': endID,
        'order': order,
        'since': since,
        'end': end
      },
    );
  }

  /// Get current trader's book order.
  Future<Map<String, dynamic>> getOpenOrders(
      {final String pair = 'btc_idr'}) async {
    return await _fetch(
      badan: {
        'method': 'openOrders',
        'pair': pair,
      },
    );
  }

  /// Get order history (canceled, success, etc).
  Future<Map<String, dynamic>> getOrderHistory(
      {final String pair = 'btc_idr',
      final int? count,
      final int? from}) async {
    return await _fetch(
      badan: {
        'method': 'orderHistory',
        'pair': pair,
        'count': count,
        'from': from
      },
    );
  }

  /// get detail of order.
  Future<Map<String, dynamic>> getOrder(
      {final String pair = 'btc_idr', required final int orderID}) async {
    return await _fetch(
      badan: {
        'method': 'getOrder',
        'pair': pair,
        'order_id': orderID,
      },
    );
  }

  /// Do cancel order in current trader's book order.
  Future<Map<String, dynamic>> cancelOrder({
    final String pair = 'btc_idr',
    required final int orderID,
    final String type = 'buy',
  }) async {
    return await _fetch(
      badan: {
        'method': 'cancelOrder',
        'pair': pair,
        'order_id': orderID,
        'type': type,
      },
    );
  }

  /*
    TODO:
    withdrawFee
    withdrawCoin
    listDownline
    checkDownline
    createVoucher (Partner Only)
  */

  /// Close connection, you can't open connection anymore. Instead you must create new object.
  close() {
    _client.close();
  }
}
