import 'package:indodax/indodax.dart';

Future<void> main() async {
  var ujang = PrivateAPI(
    key: 'OOZJORLL-XFEC6V3D-EDUZHELU-PHP8YF9F-GSSXV2K6',
    secret:
        'b11c56f740d358b1640e17beb72bd3c137b58b02170aa4f3cf28327c3f87fb73cc4e6b3085b7f7fb',
  );
  var infoUjang = await ujang.getOpenOrders(pair: 'btc_idr');
  print(
      infoUjang); // It will return invalid credential, use your own credential!
  ujang.close();
}
