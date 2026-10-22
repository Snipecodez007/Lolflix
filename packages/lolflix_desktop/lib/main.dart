import 'package:rhttp/rhttp.dart';
import 'package:lolflix/services/network_client_factory.dart';
import 'package:lolflix/main.dart' as core_main;

void main() async {
  await Rhttp.init();
  NetworkClientFactory.registerClientBuilder(() {
    return RhttpCompatibleClient.createSync();
  });

  core_main.main();
}
