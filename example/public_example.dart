import 'package:indodax/indodax.dart';

Future<void> main() async {
  var response = await PublicAPI.getTicker(id: 'btc_idr');
  print(response.id);
  print(response.high);
  print(response.low);
  print(response.last);
}
