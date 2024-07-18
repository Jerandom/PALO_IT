import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchImages(int page, int limit) async {
  final response = await http.get(Uri.parse('https://picsum.photos/v2/list?page=$page&limit=$limit'));

  if (response.statusCode == 200)
  {
    return json.decode(response.body);
  }

  else
  {
    throw Exception('Invalid Response');
  }
}