import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:sail_live_mobile/services/database.dart';

const token =
    'a74ddcb6776be1e3f1e2cb9ae405c4f67ea7e1fd90267d02e7cd3886dfee6916';

const url = 'https://api.daily.co/v1/rooms';

Future startEvent(String eventId) async {
  final _database = Database();
  final body = {
    'name': eventId,
    'properties': {
      'enable_chat': false,
      'start_video_off': false,
      'start_audio_off': false,
    }
  };
  final headers = {
    'content-type': 'application/json',
    'authorization': 'Bearer $token',
  };

  final response =
      await http.post(url, body: convert.jsonEncode(body), headers: headers);

  if (response.statusCode != 200) {
    final body = convert.jsonDecode(response.body);
    return {'isValid': false, 'body': body};
  }

  final resBody = convert.jsonDecode(response.body);
  await _database.startEvent(eventId, resBody['url']);
  return {'isValid': true, 'body': resBody};
}
