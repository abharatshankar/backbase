import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client client;
  ApiClient(this.client);

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    try {
      final response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}