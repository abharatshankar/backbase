import 'dart:convert';
import 'package:backbase/core/network/api_client.dart';
import 'package:backbase/data/datasources/book_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

class MockClient extends http.BaseClient {
  final http.Response response;
  MockClient(this.response);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return http.StreamedResponse(
      Stream.value(response.bodyBytes), response.statusCode,
      request: request,
    );
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    return response;
  }
}

void main() {
  test('Empty result returns empty list', () async {
    final client = MockClient(http.Response(jsonEncode({'docs': []}), 200));
    final datasource = BookRemoteDatasource(client);

    final result = await datasource.searchBooks('zzz', 1);
    expect(result, isEmpty);
  });

  test('API error throws exception', () async {
    final client = MockClient(http.Response('Server Error', 500));
    final datasource = BookRemoteDatasource(client);

    expect(
      () async => await datasource.searchBooks('fail', 1),
      throwsException,
    );
});
  
}
