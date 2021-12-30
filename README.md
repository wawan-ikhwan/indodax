A simple asynchronous API Client Indodax

This library is implementing [Indodax Official API](https://github.com/btcid/indodax-official-api-docs).

[![Indodax Official API](https://indodax.com/homepage-assets/favicon.ico)](https://github.com/btcid/indodax-official-api-docs)

This package contains a set of high-level functions and classes that make it
easy to consume API.

## Using
1. Public API example:

    You don't need authenticate for PublicAPI.
    * Synchronous
    
    Get server time example:
    ```dart
    import 'package:indodax/indodax.dart';

    void main(){
      PublicAPI.summaries.then((t) {
        print(t.timeZone);
        print(t.time);
        });
    }
    ```
    * Asynchronous ***[Recommended]***

    Get server time example:
    ```dart
    import 'package:indodax/indodax.dart';

    Future<void> main() async {
      var response = await PublicAPI.serverTime;
      print(response.timeZone);
      print(response.time);
    }
    ```
    Get summaries example:
    ```dart
    import 'package:indodax/indodax.dart';

    Future<void> main() async {
      var response = await PublicAPI.summaries;
      print(response.prices7d);
      print(response.prices24h);
    }
    ```
2. Private API:

    You need **API_KEY** and **SECRET KEY** for Private API, you can make it with visit https://indodax.com/trade_api .

    Get info trader (ujang)
    ```dart
    import 'package:indodax/indodax.dart';

    Future<void> main() async {
      var ujang = PrivateAPI(key:'OOZJORLL-XFEC6V3D-EDUZHELU-PHP8YF9F-GSSXV2K6',secret:'b11c56f740d358b1640e17beb72bd3c137b58b02170aa4f3cf28327c3f87fb73cc4e6b3085b7f7fb');
      var infoUjang = await ujang.info
      print(infoUjang);
    }
    ```
    Or you can use valid **auth.json** file

    ```json
    {
      "API": "OOZJORLL-XFEC6V3D-EDUZHELU-PHP8YF9F-GSSXV2K6",
      "SECRET": "b11c56f740d358b1640e17beb72bd3c137b58b02170aa4f3cf28327c3f87fb73cc4e6b3085b7f7fb"
    }
    ```
    Then you can use specified path where you saved the file.
    ```dart
    import 'package:indodax/indodax.dart';

    Future<void> main() async {
      var ujang = PrivateAPI(authPath:'auth.json');
      var infoUjang = await ujang.info
      print(infoUjang);
    }
    ```