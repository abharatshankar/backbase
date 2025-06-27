import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client client;
  ApiClient(this.client);

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    return client.get(url, headers: headers);
  }
}
