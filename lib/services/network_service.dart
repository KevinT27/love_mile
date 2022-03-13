import 'package:http/http.dart' as http;

class NetworkService {
  Future<http.Response> fetchData(String uri) {
    return http.get(Uri.parse(uri));
  }
}
